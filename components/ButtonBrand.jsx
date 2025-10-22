import { Pressable, Text } from "react-native";

const ButtonBrand = ({ text, fxn , disabled }) => {
  return (
    <Pressable mode="contained" onPress={fxn} disabled={disabled} className={`rounded-xl p-4 ${disabled ? 'bg-gray-300' : 'bg-primary'}`}>
      <Text className="text-white text-center font-semibold text-lg">
        {text}
      </Text>
    </Pressable>
  );
};

export default ButtonBrand;
