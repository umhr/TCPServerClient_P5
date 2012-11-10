import processing.net.Client;
import processing.net.Server;
import java.awt.Event;
import java.awt.Button;
import java.awt.TextField;
import java.awt.TextArea;
import java.awt.Checkbox;

Server myServer;

TextField portTF = new TextField("8087");
Button bindButton = new Button("Bind");
TextField inputTF = new TextField("input");
Button sendButton = new Button("Send");
TextArea logArea = new TextArea("");

Checkbox echoCheck = new Checkbox("set Echo", true);

void setup() { 
  size(465, 465);
  fill(0);
  text("Port", 210, 22);
  
  add(portTF);
  add(bindButton);
  add(inputTF);
  sendButton.setEnabled(false);
  add(sendButton);
  add(logArea);
  add(echoCheck);
} 

void draw() {
  // 移動してくれない場合があるので、移動するまで処理を行う
  if(logArea.getX() != 8){
    setUI();
  }
  if (myServer !=null) {
    readText();
  }
}

void readText(){
  Client thisClient = myServer.available();
  if (thisClient !=null) {
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid != null) {
      String message = thisClient.ip() + ": " + whatClientSaid;
      onEcho(message);
      appendText(message);
    }
  }
}

void onEcho(String message){
  if(echoCheck.getState()){
    myServer.write("Echo -- " + message);
  }
}

void setUI(){
  portTF.setBounds(250,8,100,20);
  bindButton.setBounds(357,8,100,20);
  inputTF.setBounds(8,40,345,20);
  sendButton.setBounds(357,40,100,20);
  logArea.setBounds(8,70,345,240);
  echoCheck.move(357,250);
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
  int port = Integer.parseInt(portTF.getText());
  // 8087
  myServer = new Server(this, port);
  bindButton.setEnabled(false);
  sendButton.setEnabled(true);
}

void onSend(){
  println("Send");
  String message = inputTF.getText();
  myServer.write(message);
  appendText("Sending: " + message);
  inputTF.setText("");
}

void serverEvent(Server someServer, Client someClient) {
  appendText("We have a new client: " + someClient.ip());
}

void appendText(String message){
  message += "\n" + logArea.getText();
  logArea.setText(message);
}

