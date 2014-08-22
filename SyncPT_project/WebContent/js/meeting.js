// 2013, @muazkh - https://github.com/muaz-khan
// MIT License   - https://www.webrtc-experiment.com/licence/
// Documentation - https://github.com/muaz-khan/WebRTC-Experiment/

(function () {
   'use strict';
    // RTC 기능 관련 변수
   var RTCPeerConnection, RTCSessionDescription, RTCIceCandidate, isFirefox, isChrome, STUN, TURN, iceServers, optionalArgument, offerAnswerConstraints, Offer, Answer;

    // RTC 기능 관련 설정(chrome, firefox(nightly) 지원 변수 설정)
    RTCPeerConnection = window.mozRTCPeerConnection || window.webkitRTCPeerConnection;
    RTCSessionDescription = window.mozRTCSessionDescription || window.RTCSessionDescription;
    RTCIceCandidate = window.mozRTCIceCandidate || window.RTCIceCandidate;

    navigator.getUserMedia = navigator.mozGetUserMedia || navigator.webkitGetUserMedia;
    window.URL = window.webkitURL || window.URL;

    isFirefox = !!navigator.mozGetUserMedia;
    isChrome = !!navigator.webkitGetUserMedia;

    //Session Traversal Utilities for NAT 주소
    //사용자의 사설IP가 아닌 공인IP주소 제공
    STUN = {
        url: isChrome ? 'stun:stun.l.google.com:19302' : 'stun:23.21.150.121'
    };

    //Traversal Using Relays around NAT 주소
    //P2P 연결 실패시 우회하여 접근 가능한 주소 제공
    TURN = {
        url: 'turn: oh4851@gmail.com@numb.viagenie.ca',
        credential: 'syncpt'
    };

    //Interactive Connectivity Establishment (framework For connecting peers)
    //SDP Offer 내의 여러 IP주소, 포트를 포함하고 P2P 연결 확인 후에 미디어 전송
    //만일 연결 확인을 통해 P2P 연결할 수 없다면, TURN을 이용
    iceServers = {
        iceServers: [STUN]
    };

    if (isChrome) {
        if (parseInt(navigator.userAgent.match( /Chrom(e|ium)\/([0-9]+)\./ )[2]) >= 28)
            TURN = {
                url: 'turn:numb.viagenie.ca',
                credential: 'syncpt',
                username: 'oh4851@gmail.com'
            };

        iceServers.iceServers = [STUN, TURN];
    }

    optionalArgument = {
        optional: [{
            DtlsSrtpKeyAgreement: true
        }]
    };

    offerAnswerConstraints = {
        optional: [],
        mandatory: {
            OfferToReceiveAudio: true,
            OfferToReceiveVideo: true
        }
    };

    function getToken() {
        return (Math.random() * new Date().getTime()).toString(36).replace( /\./g , '');
    }

    function onSdpSuccess() {}

    function onSdpError(e) {
        console.error('sdp error:', JSON.stringify(e, null, '\t'));
    }

    Offer = {
        createOffer: function (config) {
            var peer = new RTCPeerConnection(iceServers, optionalArgument);

            if (config.stream) peer.addStream(config.stream);

            peer.onaddstream = function (event) {
                config.onaddstream(event.stream, config.to);
            };

            peer.onicecandidate = function (event) {
                config.onicecandidate(event.candidate, config.to);
            };

            peer.createOffer(function (sdp) {
                peer.setLocalDescription(sdp);
                config.onsdp(sdp, config.to);
            }, onSdpError, offerAnswerConstraints);

            function sdpCallback() {
                config.onsdp(peer.localDescription, config.to);
            }

            this.peer = peer;

            return this;
        },
        setRemoteDescription: function (sdp) {
            this.peer.setRemoteDescription(new RTCSessionDescription(sdp), onSdpSuccess, onSdpError);
        },
        addIceCandidate: function (candidate) {
            this.peer.addIceCandidate(new RTCIceCandidate({
                sdpMLineIndex: candidate.sdpMLineIndex,
                candidate: candidate.candidate
            }));
        }
    };

    Answer = {
        createAnswer: function (config) {
            var peer = new RTCPeerConnection(iceServers, optionalArgument);

            if (config.stream) peer.addStream(config.stream);

            peer.onaddstream = function (event) {
                config.onaddstream(event.stream, config.to);
            };

            peer.onicecandidate = function (event) {
                config.onicecandidate(event.candidate, config.to);
            };

            peer.setRemoteDescription(new RTCSessionDescription(config.sdp), onSdpSuccess, onSdpError);
            peer.createAnswer(function (sdp) {
                peer.setLocalDescription(sdp);
                config.onsdp(sdp, config.to);
            }, onSdpError, offerAnswerConstraints);

            this.peer = peer;

            return this;
        },
        addIceCandidate: function (candidate) {
            this.peer.addIceCandidate(new RTCIceCandidate({
                sdpMLineIndex: candidate.sdpMLineIndex,
                candidate: candidate.candidate
            }));
        }
    };
   
    // a middle-agent between public API and the Signaler object
    window.Meeting = function (channel, brtype, conntype, userid) {
       var isInitiator, signaler, self;
        self = this;
        this.channel = channel || location.href.replace(/\/|:|#|%|\.|\[|\]/g, '');

        // get alerted for each new meeting
        this.onmeeting = function (room) {
            self.meet(room);
        };

        function initSignaler() {
            signaler = new Signaler(self, userid);
        }

        //RTC연결 전에 MediaStream 획득 시도하는 function
        function captureUserMedia(callback) {
            if (isInitiator || !conntype) {
                var constraints;
                if (brtype === 'audio') {
                    constraints = {
                        audio: true,
                        video: false
                    };
                }
                else {
                    constraints = {
                        audio: true,
                        video: true
                    };
                }
            
                navigator.getUserMedia(constraints, onstream, onerror);
            } else {
                callback();
            }

            function onstream(stream) {
               //alert('This is Magic');
                self.stream = stream;
                var contents;
                if (brtype === 'audio') {
                    contents = document.createElement('audio');
                }
                else {
                    contents = document.createElement('video');
                }
                contents.id = 'self';
                contents[isFirefox ? 'mozSrcObject' : 'src'] = isFirefox ? stream : window.webkitURL.createObjectURL(stream);
                contents.autoplay = true;
                contents.controls = true;
                contents.muted = true;
                contents.play();

                self.onaddstream({
                    contents: contents,
                    stream: stream,
                    userid: 'self',
                    type: 'local'
                });

                callback(stream);
            }

            function onerror(e) {
                console.error(e);
            }
        }

        //사용자의 RTC여부 변수 set
        this.setInRtc = function (result) {
           signaler.setInRtc(result);
        };
        
        //Host일 경우 RTC연결 시 제공할 Media획득 시도, 필요 정보 Server에 전송
        this.setup = function (roomid, isOpen) {
            isInitiator = true;
            captureUserMedia(function () {
                !signaler && initSignaler();
                signaler.broadcast({
                    roomid: roomid || self.channel,
                    isOpen: isOpen
                });
            });
        };

        //Guest일 경우 RTC연결 시 제공할 Media획득 시도, 필요 정보 Server에 전송
        this.meet = function (room) {
            isInitiator = false;
            captureUserMedia(function () {
                !signaler && initSignaler();
                signaler.trysignal({
                    roomid: room
                });
            });
        };

        this.selectfile = function(room, file) {
           var type, data;
           type = 'selectfile';
           data = {
                to: room,
                file: file
            };
            signaler.sendInterface(type, data);
        };

        this.enterroom = function(room, uid) {
           var type, data;
           type = 'enter_room';
           data = {
                to: room,
                userid: uid
            };
            signaler.sendInterface(type, data);
        };

        this.control = function(room, index) {
           var type, data;
           type = 'slide_control';
           data = {
             to: room,
                index: index
            };
            signaler.sendInterface(type, data);
        };
        
        this.slideShow = function(room, file, show) {
           var type, data;
           type = 'slide_show';
           data = {
             to: room,
                file: file,
                show: show
            };
            signaler.sendInterface(type, data);
        };

        this.c_request = function(room, uid) {
           var type, data;
           type = 'c_request';
           data = {
              to: room,
                 from: uid
            };
            signaler.sendInterface(type, data);
        };

        this.c_accept = function(room, uid) {
           var type, data;
           type = 'c_accept';
           data = {
                to: room,
                receiver: uid
            };
            signaler.sendInterface(type, data);
        };

        this.request_stop = function(room, uid) {
           var type, data;
           type = 'request_stop';
           data = {
                to: room,
                receiver: uid
            };
            signaler.sendInterface(type, data);
        };

        this.request_cancel = function(room, uid) {
           var type, data;
           type = 'request_cancel';
           data = {
               to: room,
               receiver: uid
            };
           signaler.sendInterface(type, data);
        };
        
        this.refuse = function(room, uid) {
           var type, data;
           type = 'refuse';
           data = {
               to: room,
               receiver: uid
            };
           signaler.sendInterface(type, data);
        };
        
        this.tryOfferInfo = function (room, uid) {
           var type, data;
           type = 'tryRoomInfo';
           data = {
              to: room,
               userid: uid
           };
           signaler.sendInterface(type, data);
        };
        
        this.tryRoomInfo = function (room, userid, file, index, max, hide, point) {
           var type, data;
           type = 'tryRoomInfo';
           data = {
                to: room,
                userid: userid,
                file: file,
                index: index,
                max: max,
                hide: hide,
                point: point
            };
            signaler.sendInterface(type, data);
        };

        this.chat = function(room, chat_msg, u_name) {
           var type, data;
           type = 'chat';
           data = {
                to: room,
                chat_msg: chat_msg,
                u_name: u_name
            };
            signaler.sendInterface(type, data);
        };

        this.syncPoint = function(action, room, line) {
           var type, data;
           type = 'syncPoint';
           data = {
               action: action,
                to: room,
                linedata: line
            };
            signaler.sendInterface(type, data);
        };
        
        // check pre-created meeting rooms
        this.check = initSignaler;
    };

    // it is a backbone object
    function Signaler(root, id) {
        // unique identifier for the current user
        //var userid = root.userid || getToken();
       var userid, signaler, peers, candidates, options, inRtc, socket;
        // self instance
        signaler = this;        
        userid = id;
        // object to store all connected peers
        peers = {};
        inRtc = false;

        // custom signalling implementations
        // e.g. WebSocket, Socket.io, SignalR, WebSycn, XMLHttpRequest, Long-Polling etc.
        socket = root.openSignalingChannel(function (message) {
            if (message.userid != userid) {
                if (message.leaving && root.onuserleft) root.onuserleft(message);
                else signaler.onmessage(message);
            }
        });

        //Signaling을 통한 RTC와 연관된 io메시지 보내는 function
        this.signal = function (data) {
            data.userid = userid;
            data.roomid = root.channel;
            socket.emit('message', data);
        };
        
        //RTC연결과 직접 관련 없는 io메시지 보내는 function
        this.sendInterface = function (type, data) {
            socket.emit(type, data);
        };

        // Signaling과 관련된 message handle을 위한 function
        this.onmessage = function (message) {
            if (message.to == userid) {
                // for pretty logging
                console.debug(JSON.stringify(message, function (key, value) {
                    if (value && value.sdp) {
                        console.log(value.sdp.type, '---', value.sdp.sdp);
                        return '';
                    } else return value;
                }, '---'));
            }

            // if someone shared SDP
            if (message.sdp && message.to == userid) {
                this.onsdp(message);
            }

            // if someone shared ICE
            if (message.candidate && message.to == userid) {
                this.onice(message);
            }

            // if someone sent participation request
            if (message.participationRequest && message.to == userid) {
                var _options = options;
                _options.to = message.userid;
                _options.stream = root.stream;
                peers[message.userid] = Offer.createOffer(_options);
            }
        };

        //SDP message 도착 시 handle하는 function
        this.onsdp = function (message) {
            var sdp = message.sdp;

            if (sdp.type == 'offer') {
                var _options = options;
                _options.stream = root.stream;
                _options.sdp = sdp;
                _options.to = message.userid;
                peers[message.userid] = Answer.createAnswer(_options);
            }

            if (sdp.type == 'answer') {
                peers[message.userid].setRemoteDescription(sdp);
            }
        };

        // object to store ICE candidates for answerer
        candidates = [];

        //ICE message 도착 시 handle하는 fucntion
        this.onice = function (message) {
            var peer = peers[message.userid];
            if (peer) {
                peer.addIceCandidate(message.candidate);
                for (var i = 0; i < candidates.length; i++) {
                    peer.addIceCandidate(candidates[i]);
                }
                candidates = [];
            } else {
               candidates.push(candidates);
            }
        };

        // it is passed over Offer/Answer objects for reusability
        options = {
            onsdp: function (sdp, to) {
                signaler.signal({
                    sdp: sdp,
                    to: to
                });
            },
            onicecandidate: function (candidate, to) {
                signaler.signal({
                    candidate: candidate,
                    to: to
                });
            },
            onaddstream: function (stream, _userid) {
                console.debug('onaddstream', '>>>>>>', stream);

                stream.onended = function () {
                    if (root.onuserleft) root.onuserleft(_userid);
                };

                var contents;
                if (brtype === 'audio') {
                    contents = document.createElement('audio');
                }
                else {
                    contents = document.createElement('video');
                }

                contents.id = 'partin';
                contents[isFirefox ? 'mozSrcObject' : 'src'] = isFirefox ? stream : window.webkitURL.createObjectURL(stream);
                contents.autoplay = true;
                contents.controls = true;

                contents.addEventListener('play', function () {
                    setTimeout(function () {
                        contents.muted = false;
                        contents.volume = 1;
                        afterRemoteStreamStartedFlowing();
                    }, 3000);
                }, false);

                contents.play();

                function afterRemoteStreamStartedFlowing() {
                    if (!root.onaddstream) return;
                    root.onaddstream({
                        contents: contents,
                        stream: stream,
                        userid: 'partin',
                        type: 'remote'
                    });
                }
            }
        };

        this.setInRtc = function (result) {
            inRtc = result;
        };
        
        // call only for session initiator
        this.broadcast = function (_config) {
           var rtcMax;
            signaler.roomid = _config.roomid || getToken();
            signaler.isbroadcaster = true;
            if (conntype) {
               rtcMax = 16;
            } else {
               rtcMax = 2;
            }
            var data = {
                to: signaler.roomid,
                userid: userid,
                rtcMax: rtcMax,
                isOpen: _config.isOpen
            };
            socket.emit('create', data);

            // if broadcaster leaves; clear all JSON files from Firebase servers
            if (socket.onDisconnect) socket.onDisconnect().remove();
        };
        
        // called for each new participant
        this.trysignal = function (_config) {
            var data = {
                participationRequest: true,
                to: _config.roomid,
                userid: userid
            };
            socket.emit('trysignal', data);
            signaler.sentParticipationRequest = true;
        };
        
        window.onbeforeunload = function () {
            leaveRoom();
            // return 'You\'re leaving the session.';
        };

        window.onkeyup = function (e) {
            if (e.keyCode == 116) {
                leaveRoom();
            }
        };

        //참여자 종료 시 동작하는 function
        function leaveRoom() {
            var data = {
                leaving: true,
               rtc: inRtc,
               userid: userid,
                to: root.channel
            };
            socket.emit('leave', data);

            // stop broadcasting room
            if (signaler.isbroadcaster) signaler.stopBroadcasting = true;

            // leave user media resources
            if (root.stream) root.stream.stop();
        }
        root.leave = leaveRoom;
    }
})();