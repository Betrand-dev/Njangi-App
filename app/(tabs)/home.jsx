import React from "react";
import { View, Text, TouchableOpacity, ScrollView, Image, Pressable } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { Eye, Bell } from "lucide-react-native";

export default function WalletScreen() {
  const [view, setView] = React.useState(false);
  return (
    <SafeAreaView className="flex-1 bg-background">
      <ScrollView
        showsVerticalScrollIndicator={false}
        className="px-4 pt-2 space-y-6"
      >
        {/* Header */}
        <View className="flex-row items-center justify-between mt-2 mb-4">
          <View className="flex-row items-center space-x-2">
            <View className="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center">
              <Text className="font-bold text-gray-700">AB</Text>
            </View>
            <Text className="text-lg font-semibold">
              Hello <Text className="text-black">Akum!</Text> 👋
            </Text>
          </View>
          <Bell className="text-primary" />
        </View>

        {/* transaction  */}
        <View className="bg-gray-100 rounded-2xl p-12">
          <Text className="text-gray-500 text-center font-bold">Week Contribution</Text>
          <View className="flex-row justify-center items-center mt-1">
            <Text className="text-gray-800 font-semibold mr-2">XAF</Text>
            <Text className="text-2xl font-bold tracking-widest">{view ? "5000" : "****"}</Text>
            <Pressable className="ml-2" onPress={() => setView(!view)}>
              <Eye size={18} color="gray" />
            </Pressable>
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
