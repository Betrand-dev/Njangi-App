import { View } from "react-native";
import { TextInput } from "react-native-paper";

const Tryer = () => {
  return (
    <View className="flex-1 justify-center self-center">
      <TextInput
      className=""
      style={{marginBottom: 15,
    borderRadius: 30,
    borderWidth: 2,
    borderColor: "#ccc",
    borderRadius: 25,
    paddingVertical: 18,
    paddingHorizontal: 25,
    fontSize: 16,}}
        mode="outlined"
        label="Outlined input"
        placeholder="Type something"
        right={<TextInput.Icon icon="eye" />}
      />
    </View>
  );
};

export default Tryer;
