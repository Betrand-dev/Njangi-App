import React from "react";
import { View, Text, TouchableOpacity, ScrollView, Image, Pressable, Alert } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import useModal from "../../hooks/useModal";
import ModalBrand from "../../components/ModalBrand";
import { Eye, EyeOffIcon , Bell } from "lucide-react-native";
import { router } from "expo-router";

export default function WalletScreen() {
  const [view, setView] = React.useState(false);
  const [isLoading, setIsLoading] = React.useState(true);
  const showNotification = useModal();
  const load = () =>{
    if(isLoading){
              Alert.alert(
                'trying',
                'chia what am i doiing',
                [
                  {text: 'Cancel', style:"cancel"},
                  {text: "discard", onPress: () => setIsLoading(!isLoading)}
                ]
              );
            }else{
              alert("did not work");
              setIsLoading(!isLoading)
            }
  }
  return (
    <SafeAreaView className="flex-1 bg-background">
      {/* Header */}
        <View className="flex-row items-center pt-5 pb-5 px-3 border-b border-gray-200  justify-between">
          <View className="flex-row items-center space-x-2">
            <View className="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center">
              <Text className="font-bold text-gray-700">AB</Text>
            </View>
            <Text className="text-lg font-semibold">
              Hello <Text className="text-black">Akum!</Text> 👋
            </Text>
          </View>
          <TouchableOpacity onPress={showNotification.showModal}>
            <Bell className="text-primary" color="#8f08fdde" />
          </TouchableOpacity>
        </View>
      <ScrollView
        showsVerticalScrollIndicator={false}
        className="px-4 pt-2 space-y-6"
      >

        {/* transaction  */}
        <View className="bg-gray-100 rounded-2xl p-12">
          <Text className="text-gray-500 text-center font-bold">Week Contribution</Text>
          <View className="flex-row justify-center items-center mt-1">
            <Text className="text-gray-800 font-semibold mr-2">XAF</Text>
            <Text className="text-2xl font-bold tracking-widest">{view ? "5000" : "****"}</Text>
            <Pressable className="ml-2" onPress={() => setView(!view)}>
              {view ? <Eye size={18} color="gray" /> : <EyeOffIcon size={18} color="gray" />}
            </Pressable>
          </View>
        </View>

        {/* trying */}
        <View>
          <TouchableOpacity onPress={load}>
            <Text>load</Text>
          </TouchableOpacity>
        </View>

        {/* notification Modal */}
        <ModalBrand 
        title="Notification"
        visible={showNotification.isVissible}
        onrequestclose={showNotification.hideModal}
        content={
          <View className="self-center mt-4">
            <Text>Notificationn</Text>
          </View>
        }
        />
      </ScrollView>
    </SafeAreaView>
  );
}
