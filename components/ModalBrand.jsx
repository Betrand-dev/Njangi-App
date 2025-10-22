import { Text, ScrollView, View, Pressable, Modal } from "react-native";
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import {  CircleXIcon } from "lucide-react-native";

const ModalBrand = ({visible, onrequestclose, title , content }) => {
  return (
    <Modal
      animationType="slide"
      transparent={true}
      visible={visible}
      onRequestClose={onrequestclose}
      className="bg-background"
    >
      <View  className=" h-full bg-background w-full rounded-t-lg absolute ">
        <View className="flex-row items-center py-3 px-3 border-b border-gray-200  justify-between">
          <Text className="font-bold text-gray-500 text-lg">{title}</Text>
          <Pressable onPress={onrequestclose}>
            <CircleXIcon  color="#000" size={30} />
          </Pressable>
        </View>
        <ScrollView className="flex-1 p-4">
            {content}
        </ScrollView>
      </View>
    </Modal>
  );
};

export default ModalBrand;
