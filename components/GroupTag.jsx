import { Link, router } from "expo-router";
import { Text, TouchableOpacity, View, Pressable } from "react-native";

const GroupTag = ({
  groupId,
  groupName,
  groupType,
}) => {
  return (
   
      <TouchableOpacity className="flex flex-row items-center gap-4 mt-1 p-4 bg-white rounded-lg shadow-sm border border-gray-200"
       onPress={() => router.push({ pathname: "/groups/[id]", params: { id: groupId } })}
      >
        <View className="bg-gray-200 h-16 w-16 rounded-full flex items-center justify-center">
          <Text className="font-bold text-gray-700">
            {(groupName?.[0]?.toUpperCase() || "") +
              (groupName?.[1]?.toUpperCase() || "")}
          </Text>
        </View>
        {/* <Link href={{ pathname: "/groups/[id]", params: { id: groupId } }}> */}
        <View className="flex-1 flex-row justify-between items-center">
          <Text className="text-lg font-semibold text-gray-900">
            {groupName}
          </Text>
          <Text className="px-2 bg-primary  text-white py-1 border border-gray-300 rounded-full text-sm">
            {groupType}.
          </Text>
        </View>
      </TouchableOpacity>
      
  );
};

export default GroupTag;
