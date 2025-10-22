import { ScrollView, TouchableOpacity , Pressable ,StyleSheet, Text, View, Button } from "react-native";
import { SafeAreaView, SafeAreaProvider  } from "react-native-safe-area-context";
import { PlusCircleIcon } from "lucide-react-native";
import useModal from "../../hooks/useModal";
import ModalBrand from "../../components/ModalBrand";
import {Modal} from "react-native-paper";
import InputBrand from "../../components/InputBrand";
import ButtonBrand from "../../components/ButtonBrand"
import { useState } from "react";

const Groups = () => {
  const modal = useModal();
  const [code , setCode] = useState();
  const handleGroupSearch = () => {
    console.log(code);
  }
  return (
      <SafeAreaView className="flex-1 bg-background">

        {/* Header */}
        <View className="flex-row items-center pt-5 pb-5 px-3 border-b border-gray-200  justify-between">
          <View className="flex-row items-center space-x-2">
            <Text className="text-2xl font-semibold">Groups</Text>
          </View>
          <Pressable onPress={modal.showModal}>
            <PlusCircleIcon className="text-primary" color="#8f08fdde" />
          </Pressable>
        </View>

       <ScrollView className="space-y-6 pt-3 px-4 pb-4">
        <View className="mt-80">
          <Text className="text-center font-bold text-2xl text-gray-400 mb-2">No Group found</Text>
          <TouchableOpacity className="text-center" onPress={modal.showModal}>
            <Text className="text-center text-primary font-semibold"> Add a group </Text>
          </TouchableOpacity>
        </View>


      <ModalBrand 
      visible={modal.isVissible} 
      onrequestclose={modal.hideModal} 
      title="Add Group"
      content={
        <View className="">
          {/* Join group with group-code */}
          <View className="my-10 mx-6">
            <InputBrand placeholder="Group code" value={code} onchange={setCode} secure={false} />
            <ButtonBrand text="Find" fxn={handleGroupSearch} />
          </View>
          <TouchableOpacity className="content-center text-center ">
            <Text className="text-center text-primary">Create A Group</Text>
          </TouchableOpacity>
        </View>
      }
      />


      </ScrollView>
      </SafeAreaView>
  );
};

export default Groups;
