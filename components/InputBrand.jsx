import { TextInput } from "react-native";

const InputBrand = ({ value, onchange, placeholder,  type }) => {
  if (type == 'number') {
    return (
      <TextInput
        className="border-2 mb-2 p-4 rounded-lg border-gray-300"
        value={value}
        onChangeText={onchange}
        placeholderTextColor="#9CA3AF"
        placeholder={placeholder ? placeholder : ""}
        keyboardType="phone-pad"
      />
    );
  } else if(type == 'email') {
    return (
      <TextInput
        className="border-2 mb-2 p-4 rounded-lg border-gray-300"
        value={value}
        onChangeText={onchange}
        placeholderTextColor="#9CA3AF"
        placeholder={placeholder ? placeholder : ""}
        keyboardType="email-address"
      />
    );
  }
  else if(type == 'password'){
    return (
      <TextInput
        className="border-2 mb-2 p-4 rounded-lg border-gray-300"
        secureTextEntry={true}
        value={value}
        onChangeText={onchange}
        placeholderTextColor="#9CA3AF"
        placeholder={placeholder ? placeholder : ""}
      />
    );
  }
  else {
    return (
      <TextInput
        className="border-2 mb-2 p-4 rounded-lg border-gray-300"
        value={value}
        onChangeText={onchange}
        placeholderTextColor="#9CA3AF"
        placeholder={placeholder ? placeholder : ""}
      />
    );
  }
};

export default InputBrand;
