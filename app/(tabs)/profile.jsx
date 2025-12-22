import { Image } from "expo-image";
import { CircleArrowRight, Edit } from "lucide-react-native";
import { useContext } from "react";
import {
  Alert,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import ModalBrand from "../../components/ModalBrand";
import useModal from "../../hooks/useModal";
import useRequireAuth from "../../hooks/useRequireAuth";
import { AuthContext } from "../contexts/AuthContext";

const Profile = () => {
  const profileModal = useModal();
  const { user, loading } = useRequireAuth();
  const { logout } = useContext(AuthContext);

  const handleLogout = () => {
    Alert.alert("Logout", "Are you sure you want to logout?", [
      {
        text: "Cancel",
        style: "cancel",
      },
      {
        text: "Logout",
        style: "destructive",
        onPress: logout,
      },
    ]);
  };

  const profile = user?.profile;
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
            <Image
              source={require("../../assets/images/placeholder2.png")}
              className="w-32 rounded-full h-32"
            />
          </View>
          <View className="self-center mt-4">
            <Text className="text-center font-bold text-xl">
              {profile?.firstName} {profile?.lastName}
            </Text>
            <Text className="text-center text-gray-500">{profile?.email}</Text>
          </View>
        </View>

        {/* personal informations */}
        <View className="mt-20">
          <TouchableOpacity
            onPress={profileModal.showModal}
            className="flex-row justify-between p-5 bg-gray-200 rounded-xl mb-2 border-gray-400"
          >
            <Text className="font-semibold text-lg">Profile</Text>
            <CircleArrowRight color="#8f08fdde" />
          </TouchableOpacity>

          <TouchableOpacity className="flex-row justify-between p-5 bg-gray-200 rounded-xl mb-2 border-gray-400">
            <Text className="font-semibold text-lg">Dark Mode</Text>
            <CircleArrowRight color="#8f08fdde" />
          </TouchableOpacity>

          <TouchableOpacity className="flex-row justify-between p-5 bg-gray-200 rounded-xl mb-2 border-gray-400">
            <Text className="font-semibold text-lg">Invite Friend</Text>
            <CircleArrowRight color="#8f08fdde" />
          </TouchableOpacity>
        </View>

        {/* logout button */}
        <TouchableOpacity
          onPress={handleLogout}
          className="mt-12 flex-row justify-center p-5 bg-red-500 rounded-full mb-2"
        >
          <Text className="font-semibold text-lg text-white">Logout</Text>
        </TouchableOpacity>

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
