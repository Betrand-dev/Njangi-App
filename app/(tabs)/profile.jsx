import { StyleSheet, Text, View , Pressable, TouchableOpacity, ScrollView , ImageSourcePropType} from "react-native";
import { SafeAreaView, SafeAreaProvider  } from "react-native-safe-area-context";
import { Edit } from "lucide-react-native";
import { Image } from 'expo-image';
import { CircleArrowRight } from "lucide-react-native";
import useModal from "../../hooks/useModal";
import ModalBrand from "../../components/ModalBrand";

const Profile = () => {
  const profileModal = useModal();
  return (
      <SafeAreaView className="flex-1 bg-background">
        {/* Header */}
        <View className="flex-row items-center pt-5 pb-5 px-3 border-b border-gray-200  justify-between">
          <View className="flex-row items-center space-x-2">
            <Text className="text-2xl font-semibold">Profile</Text>
          </View>
          <Pressable onPress={profileModal.showModal}>
            <Edit className="text-primary" color="#8f08fdde" />
          </Pressable>
        </View>

        {/* contents */}
        <ScrollView className="space-y-6 pt-3 px-4 pb-4">
          {/* profile */}
          <View className="border border-primary rounded-2xl p-6">
            <View className="bg-gray-300 w-32 h-32 rounded-full self-center">
              <Image  source={require('../../assets/images/placeholder2.png')} className="w-32 rounded-full h-32" />
            </View>
            <View className="self-center mt-4">
              <Text className="text-center font-bold text-xl">Akum Betrand</Text>
              <Text className="text-center text-gray-500">betrand@gmail.com</Text>
            </View>
          </View>

          {/* personal informations */}
          <View className="mt-20">
            <TouchableOpacity onPress={profileModal.showModal} className="flex-row justify-between p-5 bg-gray-200 rounded-xl mb-2 border-gray-400">
              <Text className="font-semibold text-lg">Profile</Text>
              <CircleArrowRight color="#8f08fdde"/>
            </TouchableOpacity>

            <TouchableOpacity className="flex-row justify-between p-5 bg-gray-200 rounded-xl mb-2 border-gray-400">
              <Text className="font-semibold text-lg">Dark Mode</Text>
              <CircleArrowRight color="#8f08fdde"/>
            </TouchableOpacity>

            <TouchableOpacity className="flex-row justify-between p-5 bg-gray-200 rounded-xl mb-2 border-gray-400">
              <Text className="font-semibold text-lg">Invite Friend</Text>
              <CircleArrowRight color="#8f08fdde"/>
            </TouchableOpacity>

          </View>

          {/* contact support */}
          <View className="self-center mt-10 pt-4">
            <TouchableOpacity>
              <Text className="underline  text-primary font-bold">Contact Support</Text>
            </TouchableOpacity>
          </View>

          {/* profile modal */}
          <ModalBrand 
          title="Profile"
          visible={profileModal.isVissible}
          onrequestclose={profileModal.hideModal}
          content={
            <View>
              <Text>hello world</Text>
            </View>
          }
          />
        </ScrollView>
      </SafeAreaView>
  );
};

export default Profile;

const styles = StyleSheet.create({});
