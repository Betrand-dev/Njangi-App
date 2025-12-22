import { Link } from "expo-router";
import { PlusCircleIcon, RefreshCwIcon } from "lucide-react-native";
import { useEffect, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  Pressable,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import ButtonBrand from "../../components/ButtonBrand";
import GroupTag from "../../components/GroupTag";
import InputBrand from "../../components/InputBrand";
import ModalBrand from "../../components/ModalBrand";
import useModal from "../../hooks/useModal";
import useRequireAuth from "../../hooks/useRequireAuth";
import api from "../services/api";

const Groups = () => {
  const modal = useModal();
  const { user, loading: authLoading } = useRequireAuth();
  const [code, setCode] = useState("");
  const [groups, setGroups] = useState([]);
  const [groupsLoading, setGroupsLoading] = useState(true);
  const [joinLoading, setJoinLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [activeTab, setActiveTab] = useState("all");

  useEffect(() => {
    const fetchGroups = async () => {
      if (!user) return;
      setGroupsLoading(true);
      try {
        const response = await api.get("/groups");
        setGroups(response.data.groups || []);
      } catch (error) {
        console.error("Failed to fetch groups:", error);
      } finally {
        setGroupsLoading(false);
      }
    };

    fetchGroups();
  }, [user]);

  // Filter groups based on search and tab
  const filteredGroups = groups.filter((group) => {
    const matchesSearch = group.name
      .toLowerCase()
      .includes(searchQuery.toLowerCase());
    const matchesTab = activeTab === "all" || group.group_type === activeTab;
    return matchesSearch && matchesTab;
  });

  const handleGroupSearch = async () => {
    if (!code.trim()) {
      Alert.alert("Error", "Please enter a group code");
      return;
    }

    setJoinLoading(true);
    try {
      const response = await api.post("/groups/join", { code: code.trim() });
      Alert.alert(
        "Success",
        response.data.message || "Successfully joined the group!"
      );
      setCode(""); // Clear the input
      modal.hideModal(); // Close the modal
      // Refresh the groups list
      await refreshGroups();
    } catch (error) {
      console.error("Join group error:", error);
      const errorMessage =
        error?.response?.data?.message ||
        "Failed to join group. Please check the code and try again.";
      Alert.alert("Error", errorMessage);
    } finally {
      setJoinLoading(false);
    }
  };

  const refreshGroups = async () => {
    if (!user) return;
    setGroupsLoading(true);
    try {
      const response = await api.get("/groups");
      setGroups(response.data.groups || []);
    } catch (error) {
      console.error("Failed to refresh groups:", error);
      Alert.alert("Error", "Failed to refresh groups");
    } finally {
      setGroupsLoading(false);
    }
  };

  return (
    <SafeAreaView className="flex-1 bg-background">
      {/* Header */}
      <View className="flex-row items-center pt-5 pb-5 px-3 border-b border-gray-200 justify-between">
        <View className="flex-row items-center space-x-2">
          <Text className="text-2xl font-semibold">Groups</Text>
        </View>
        <View className="flex-row items-center gap-1 space-x-3">
          <Pressable
            onPress={refreshGroups}
            disabled={groupsLoading}
            className="mr-3"
          >
            <RefreshCwIcon
              className={`text-primary ${groupsLoading ? "opacity-50" : ""}`}
              color="#8f08fdde"
            />
          </Pressable>
          <Pressable onPress={modal.showModal}>
            <PlusCircleIcon className="text-primary" color="#8f08fdde" />
          </Pressable>
        </View>
      </View>

      {/* Search and Filter Section */}
      <View className="px-4 py-3 border-b border-gray-200">
        {/* Search Input */}
        <InputBrand
          placeholder="Search groups..."
          value={searchQuery}
          onchange={setSearchQuery}
          type="text"
        />

        {/* Tab Buttons */}
        <View className="flex-row mt-3 space-x-2">
          {["all", "njangi", "savings"].map((tab) => (
            <TouchableOpacity
              key={tab}
              onPress={() => setActiveTab(tab)}
              className={`px-4 py-2 rounded-full mr-2 ${
                activeTab === tab ? "bg-primary" : "bg-gray-200"
              }`}
            >
              <Text
                className={`font-medium ${
                  activeTab === tab ? "text-white" : "text-gray-600"
                }`}
              >
                {tab.charAt(0).toUpperCase() + tab.slice(1)}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      <ScrollView
        className="space-y-6 pt-3 px-4 pb-4"
        nestedScrollEnabled={true}
      >
        {groupsLoading ? (
          <View className="flex-1 justify-center items-center mt-40">
            <ActivityIndicator size="large" color="#8f08fdde" />
          </View>
        ) : filteredGroups.length > 0 ? (
          <View className="space-y-4">
            {filteredGroups.map((group) => (
              <View className="" key={group.id}>
                <GroupTag
                  key={group.id}
                  groupId={group.id}
                  groupName={group.name}
                  groupType={group.group_type || "njangi"}
                />
              </View>
            ))}
          </View>
        ) : (
          <View className="mt-80">
            <Text className="text-center font-bold text-2xl text-gray-400 mb-2">
              {groups.length > 0
                ? "No groups match your search"
                : "No Group found"}
            </Text>
            {groups.length === 0 && (
              <TouchableOpacity
                className="text-center"
                onPress={modal.showModal}
              >
                <Text className="text-center text-primary font-semibold">
                  {" "}
                  Add a group{" "}
                </Text>
              </TouchableOpacity>
            )}
          </View>
        )}

        <ModalBrand
          visible={modal.isVissible}
          onrequestclose={modal.hideModal}
          title="Add Group"
          content={
            <View className="">
              {/* Join group with group-code */}
              <View className="my-10 mx-6">
                <InputBrand
                  placeholder="Group code"
                  value={code}
                  onchange={setCode}
                  secure={false}
                />
                {joinLoading ? (
                  <ActivityIndicator size="small" color="#8f08fdde" />
                ) : (
                  <ButtonBrand
                    text="Find"
                    fxn={handleGroupSearch}
                    disabled={joinLoading}
                  />
                )}
              </View>
              <TouchableOpacity className="content-center text-center">
                <Link href="../CreateGroup">
                  <Text className="text-center text-primary">
                    Create A Group
                  </Text>
                </Link>
              </TouchableOpacity>
            </View>
          }
        />
      </ScrollView>
    </SafeAreaView>
  );
};

export default Groups;
