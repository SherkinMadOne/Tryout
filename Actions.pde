
void keyPressed() {
  switch (key) {
    case 's':
      saveKeyData(movieFilename+".JSON");
    break;
  }
}


void saveKeyData(String fName) {
  JSONObject data = new JSONObject();
  data.setString("background",backgroundFile);
  data.setString("clip", movieFilename);
  data.setFloat("closeColourValue", 100);
  data.setString("keyColours",str(keyColours));
   data.setFloat("Frame Rate", frameRate);
  saveJSONObject(data, fName);
}