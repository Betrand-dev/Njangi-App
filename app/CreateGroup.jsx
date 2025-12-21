import { Clipboard } from "expo-clipboard";
import { router } from "expo-router";
import { useContext, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import DateTimePicker from "react-native-modal-datetime-picker";
import { SafeAreaView } from "react-native-safe-area-context";
import ButtonBrand from "../components/ButtonBrand";
import InputBrand from "../components/InputBrand";
import { AuthContext } from "./contexts/AuthContext";
import api from "./services/api";

const CreateGroup = () => {
  const { user } = useContext(AuthContext);
  const [loading, setLoading] = useState(false);
  const [groupCode, setGroupCode] = useState(null);
  const [groupData, setGroupData] = useState({
    groupName: "",
    frequency: "",
    startDate: new Date(),
    endDate: new Date(),
    amount: "",
    maxMembers: "",
    type: "",
    penalty: "",
    description: "",
    contributionTime: new Date(),
  });

  const updateGroupData = (field, value) => {
    setGroupData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  //   for date
  const [show, setShow] = useState(false);
  const dateUpdater = (selectedDate) => {
    setShow(false);
    if (selectedDate) {
      updateGroupData("startDate", selectedDate);
      console.log(groupData.startDate);
    }
  };

  //   for time
  const [showTime, setShowTime] = useState(false);
  const timeUpdater = (selectedTime) => {
    setShowTime(false);
    if (selectedTime) {
      updateGroupData("contributionTime", selectedTime);
    }
  };

  //   for end date
  const [showEnd, setShowEnd] = useState(false);
  const endDateUpdater = (selectedDate) => {
    setShowEnd(false);
    if (selectedDate) {
      updateGroupData("endDate", selectedDate);
    }
  };

  //destructuring the group info
  const {
    groupName,
    frequency,
    startDate,
    endDate,
    amount,
    maxMembers,
    type,
    penalty,
    description,
    contributionTime,
  } = groupData;

  const isFormValid = () => {
    const date = startDate.toDateString();
    const end = endDate.toDateString();
    // basic validation
    if (
      groupName.trim() !== "" &&
      frequency.trim() !== "" &&
      date.trim() !== "" &&
      end.trim() !== "" &&
      amount.trim() !== "" &&
      maxMembers.trim() !== "" &&
      type.trim() !== ""
    ) {
      return false;
    }

    return true;
  };

  const handleCreationOfGroup = async () => {
    setLoading(true);
    const data = {
      name: groupName,
      description,
      contribution_amount: parseFloat(amount),
      frequency,
      start_date: startDate.toISOString().split("T")[0], // YYYY-MM-DD
      end_date: endDate.toISOString().split("T")[0],
      max_members: parseInt(maxMembers),
      type,
      penalty: penalty ? parseFloat(penalty) : null,
      contribution_time: contributionTime.toTimeString().split(" ")[0], // HH:MM:SS
    };
    try {
      const response = await api.post("/groups", data);
      setGroupCode(response.data.group_code);
      Alert.alert("Success", "Group created successfully!");
      // Don't navigate immediately, let user see the code
    } catch (error) {
      console.error(error);
      Alert.alert("Error", "Failed to create group. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <SafeAreaView className="flex-1 p-4 bg-background">
      {/* header */}
      <View className="pt-5 pb-5 px-3 border-b border-gray-200">
        <Text className="text-xl font-semibold text-gray-700">
          Create group
        </Text>
      </View>
      {/* end of header */}
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
      >
        <ScrollView>
          <View className="flex flex-row items-center gap-4 mt-4">
            <View className="bg-gray-200 h-16 w-16 rounded-full flex items-center justify-center">
              <Text className="font-bold text-gray-700">
                {(groupName?.[0]?.toUpperCase() || "") +
                  (groupName?.[1]?.toUpperCase() || "")}
              </Text>
            </View>
            <TouchableOpacity className="px-2 py-4  border-b-2 w-64 border-gray-300">
              <Text className="text-md text-gray-500 font-semibold">
                {(groupName ? groupName : "") +
                  (type ? ` • ${type}` : "") +
                  (frequency ? ` • ${frequency}` : "") +
                  (amount ? ` • ${amount}FCFA` : "") +
                  (startDate ? ` • ${startDate.toDateString()}` : "") +
                  (endDate ? ` - ${endDate.toDateString()}` : "") +
                  (maxMembers ? ` • ${maxMembers} members` : "")}
              </Text>
            </TouchableOpacity>
          </View>

          {/* form to collect group imformations */}
          <View className="mt-10">
            {/* group name */}
            <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
              Group name
            </Text>
            <InputBrand
              value={groupData.groupName}
              type={"text"}
              placeholder={"group name"}
              onchange={(text) => updateGroupData("groupName", text)}
            />
            {/* group type */}
            <Text className="ml-2 mt-6 mb-2 font-bold text-gray-600 text-lg">
              Group Type
            </Text>
            <View className="p-2 bg-gray-200 rounded-lg flex flex-row justify-between items-center gap-1">
              {/* first choice */}
              <TouchableOpacity
                className={`${
                  type == "njangi"
                    ? "bg-primary text-white font-semibold"
                    : "bg-white text-gray-800"
                } rounded-md w-1/2 flex justify-center items-center px-4 py-6`}
                onPress={() => updateGroupData("type", "njangi")}
              >
                <View>
                  <Text>Njangi.</Text>
                </View>
              </TouchableOpacity>
              {/* second choice */}
              <TouchableOpacity
                className={`${
                  type == "savings"
                    ? "bg-primary text-white font-semibold"
                    : "bg-white"
                } w-1/2 rounded-md flex justify-center items-center px-4 py-6`}
                onPress={() => updateGroupData("type", "savings")}
              >
                <View>
                  <Text>Savings.</Text>
                </View>
              </TouchableOpacity>
            </View>

            {/* frequency(daily, weekly and monthly) */}
            <Text className="ml-2 mt-6 mb-2 font-bold text-gray-600 text-lg">
              Transaction Frequecy
            </Text>
            <View className="p-2  bg-gray-200 rounded-lg flex flex-row  items-center gap-1">
              <TouchableOpacity
                onPress={() => updateGroupData("frequency", "daily")}
                className={`${
                  frequency == "daily"
                    ? "bg-primary text-white font-semibold"
                    : "bg-white"
                }  rounded-md flex justify-center items-center px-4 py-6 w-1/3`}
              >
                <View>
                  <Text>Daily.</Text>
                </View>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => updateGroupData("frequency", "weekly")}
                className={`${
                  frequency == "weekly"
                    ? "bg-primary text-white font-semibold"
                    : "bg-white"
                }  rounded-md flex justify-center items-center px-4 py-6 w-1/3`}
              >
                <View>
                  <Text>Weekly.</Text>
                </View>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => updateGroupData("frequency", "monthly")}
                className={`${
                  frequency == "monthly"
                    ? "bg-primary text-white font-semibold"
                    : "bg-white"
                }  rounded-md flex justify-center items-center px-4 py-6 w-1/3`}
              >
                <View>
                  <Text>Monthly.</Text>
                </View>
              </TouchableOpacity>
            </View>

            {/* for frequency amount */}

            <Text className="ml-2 mt-6 mb-2 font-bold text-gray-600 text-lg">
              Contribution Amount
            </Text>

            <InputBrand
              type={"number"}
              value={amount}
              placeholder={"deposit"}
              onchange={(text) => updateGroupData("amount", text)}
              keyboardType="numeric"
            />

            {/* max members */}
            <Text className="ml-2 mt-6 mb-2 font-bold text-gray-600 text-lg">
              Max Members
            </Text>
            <InputBrand
              type={"number"}
              value={maxMembers}
              placeholder={"max members"}
              onchange={(text) => updateGroupData("maxMembers", text)}
              keyboardType="numeric"
            />

            {/* start date */}
            <Text className="ml-2 mt-6 mb-2 font-bold text-gray-600 text-lg">
              Start Date
            </Text>
            <TouchableOpacity
              className="p-4 bg-gray-200 rounded-lg"
              onPress={() => setShow(true)}
            >
              <Text>{startDate.toDateString()}</Text>
            </TouchableOpacity>
            <DateTimePicker
              isVisible={show}
              value={startDate}
              mode="date"
              display={Platform.OS === "ios" ? "spinner" : "default"}
              onConfirm={dateUpdater}
              onCancel={() => setShow(false)}
            />

            {/* end date */}
            <Text className="ml-2 mt-6 mb-2 font-bold text-gray-600 text-lg">
              End Date
            </Text>
            <TouchableOpacity
              className="p-4 bg-gray-200 rounded-lg"
              onPress={() => setShowEnd(true)}
            >
              <Text>{endDate.toDateString()}</Text>
            </TouchableOpacity>
            <DateTimePicker
              isVisible={showEnd}
              value={endDate}
              mode="date"
              display={Platform.OS === "ios" ? "spinner" : "default"}
              onConfirm={endDateUpdater}
              onCancel={() => setShowEnd(false)}
            />

            {/* contribution time */}
            <Text className="ml-2 mt-6 mb-2 font-bold text-gray-600 text-lg">
              Contribution Time
            </Text>
            <TouchableOpacity
              className="p-4 bg-gray-200 rounded-lg"
              onPress={() => setShowTime(true)}
            >
              <Text>{contributionTime.toLocaleTimeString()}</Text>
            </TouchableOpacity>
            <DateTimePicker
              isVisible={showTime}
              value={contributionTime}
              mode="time"
              display={Platform.OS === "ios" ? "spinner" : "default"}
              onConfirm={timeUpdater}
              onCancel={() => setShowTime(false)}
            />

            {/* penalty amount */}

            <Text className="ml-2 mt-6 mb-2 font-bold text-gray-600 text-lg">
              Penalty Amount
            </Text>

            <InputBrand
              type={"number"}
              value={penalty}
              placeholder={"penalty amount"}
              onchange={(text) => updateGroupData("penalty", text)}
              keyboardType="numeric"
            />

            {/* group description */}

            <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
              Group Description
            </Text>

            <InputBrand
              type={"textarea"}
              value={description}
              placeholder={"describe group"}
              onchange={(text) => updateGroupData("description", text)}
            />
          </View>
          {/* sumbmit button */}
          <View className="mt-10">
            {loading ? (
              <ActivityIndicator size="large" color="#8f08fdde" />
            ) : (
              <ButtonBrand
                text={"Create Group"}
                disabled={isFormValid() || loading}
                fxn={handleCreationOfGroup}
              />
            )}
            <TouchableOpacity>
              <Text className="underline text-primary self-center font-semibold mt-2">
                Cancel
              </Text>
            </TouchableOpacity>
          </View>
          {groupCode && (
            <View className="mt-4 p-4 bg-green-100 rounded-lg">
              <Text className="text-lg font-semibold text-center">
                Group Code: {groupCode}
              </Text>
              <TouchableOpacity
                onPress={() => Clipboard.setStringAsync(groupCode)}
                className="mt-2 p-2 bg-primary rounded self-center"
              >
                <Text className="text-white font-semibold">Copy Code</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => router.replace("/(tabs)/groups")}
                className="mt-2 p-2 bg-blue-500 rounded self-center"
              >
                <Text className="text-white font-semibold">Go to Groups</Text>
              </TouchableOpacity>
            </View>
          )}
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
};

export default CreateGroup;
