import processing.net.Client;
import java.awt.Event;
import java.awt.Button;
import java.awt.TextField;
import java.awt.TextArea;

Client myClient;

TextField addressTF = new TextField("127.0.0.1");
TextField portTF = new TextField("8087");
Button bindButton = new Button("Bind");
TextField inputTF = new TextField("input");
Button sendButton = new Button("Send");
TextArea logArea = new TextArea("");

void setup() { 
  size(465, 465);
  fill(0);
  text("Address", 8, 22);
  text("Port", 210, 22);
  
  add(addressTF);
  add(portTF);
  add(bindButton);
  add(inputTF);
  sendButton.setEnabled(false);
  add(sendButton);
  add(logArea);
} 

void draw() {
  // 移動してくれない場合があるので、移動するまで処理を行う
  if(logArea.getX() != 8){
    setUI();
  }
}

void setUI(){
  addressTF.setBounds(70,8,100,20);
  portTF.setBounds(250,8,100,20);
  bindButton.setBounds(357,8,100,20);
  inputTF.setBounds(8,40,345,20);
  sendButton.setBounds(357,40,100,20);
  logArea.setBounds(8,70,345,240);
}

// ボタンクリックの振り分け
boolean action(Event e,Object o){
  println(e);
  if(o.equals("Bind")) {
    onBind();
  }else if(o.equals("Send")) {
    onSend();
  }
  return true;
}

void onBind(){
  println("Bind");
  String address = addressTF.getText();
  int port = Integer.parseInt(portTF.getText());
  // "127.0.0.1", 8087
  myClient = new Client(this, address, port);
  bindButton.setEnabled(false);
  sendButton.setEnabled(true);
}

void onSend(){
  println("Send");
  String message = inputTF.getText();
  myClient.write(message);
  appendText("Sending: " + message);
  inputTF.setText("");
}

void clientEvent(Client someClient) {
  String message = myClient.readString();
  if(message != null){
    //println("Server Says: " + message);
    appendText("Server Says: " + message);
  }
}

void appendText(String message){
  message += "\n" + logArea.getText();
  logArea.setText(message);
}

