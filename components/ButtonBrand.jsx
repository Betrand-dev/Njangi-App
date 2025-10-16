import { Pressable, Text } from "react-native";

const ButtonBrand = ({ text, fxn }) => {
  return (
    <Pressable mode="contained" onPress={fxn} className="bg-primary rounded-xl p-4">
      <Text className="text-white text-center font-semibold text-lg">
        {text}
      </Text>
    </Pressable>
  );
};

export default ButtonBrand;
