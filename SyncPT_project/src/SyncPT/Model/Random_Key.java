package SyncPT.Model;

public class Random_Key {
    // 랜덤 생성기(0-9, A-Z, a-z)
    public int random_out()
    {
          boolean type = true;
          int out = 0;
          do{
                out = (int)((Math.random() * 74)) + 48;
                // 출력할 아스키 코드 범위를 지정함, 이범위에 들어오지 않을 경우 범위에 들어올 때까지 무한반복
                if( (out >= 48 && out <= 57) || (out >= 65 && out <= 90) || (out >= 97 && out <= 122))
                {
                      type = false;
                }
          }while(type);
          return out;
    }

    // 아스키 코드 아웃 - 등록한 숫자만큼 랜덤으로 생성하여 아웃
    public String asciiout(int num)
    {
          StringBuffer sb = new StringBuffer();
          int[] asciis = new int[num];
          for(int j =0; j < asciis.length; j++)
          {
                asciis[j] = random_out();
          }
          for(int n:asciis)
          {
                sb.append((char)n);
          }
          return sb.toString();
    }
}
