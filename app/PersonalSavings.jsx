import { router } from "expo-router";
import { ArrowLeftIcon, PlusCircleIcon, TrendingUp, RefreshCwIcon } from "lucide-react-native";
import { useState, useEffect } from "react";
import {
  Pressable,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
  Platform,
  Alert,
  ActivityIndicator
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import ButtonBrand from "../components/ButtonBrand";
import InputBrand from "../components/InputBrand";
import ModalBrand from "../components/ModalBrand";
import useModal from "../hooks/useModal";
import DateTimePicker from "react-native-modal-datetime-picker";
import { AuthContext } from "./contexts/AuthContext";
import api from "./services/api";
import useRequireAuth from "../hooks/useRequireAuth";

const PerdonalSavings = () => {
  const { user, loading: authLoading } = useRequireAuth();
    const [sendLoading, setSendLoading] = useState(false);
    const [profilesLoading, setProfilesLoading] = useState(false);
    const [profiles, setProfiles] = useState([]);
  const modal = useModal();
  const [profileData, setProfileData] = useState({
    name: "",
    goal: "",
    frequency: "",
    target_date: new Date(),
  });
  const updateProfileData = (field, value) => {
    setProfileData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  useEffect(() => {
    const fetchSavingProfiles = async () => {
      
      setProfilesLoading(true);
      try {
        const response = await api.get("/saving_profile");
        setProfiles(response.data.profile || []);
      }
      catch (error) {
        console.error("Failed to fetch groups:", error);
      } finally {
        setProfilesLoading(false);
      }
    };

    fetchSavingProfiles()
  }, [user]);

  // destructuring data
  const { name, goal, frequency, target_date } = profileData;

  const handleProfileCreation = async () => {
    setSendLoading(true);
    const data = {
      name,
      goal,
      targetDate : target_date.toISOString().split("T")[0], // YYYY-MM-DD,
      frequency,
    };
    
    try {
      const response = await api.post("/saving_profile", data);
      Alert.alert("Success", "personal Saving profile Created successfully!");
    } catch (error){
      console.error(error);
      Alert.alert("Error", "Failed to create personal profile. Please try again.");
    } finally {
      setSendLoading(false)
    }
  };

  // refresh profiles
  const refreshProfiles = async () => {
    if (!user) return;
    setProfilesLoading(true);
    try {
      const response = await api.get("/saving_profile");
      setProfiles(response.data.profile || []);
    } catch (error) {
      console.error("Failed to refresh Profile:", error);
      Alert.alert("Error", "Failed to refresh Profile");
    } finally {
      setProfilesLoading(false);
    }
  };

  // returns true when form is valid (both name and goal present)
  const isFormValid = () => {
    return name.trim() !== "" && goal.trim() !== "" && frequency.trim() !== "";
  };

  //   for date
    const [show, setShow] = useState(false);
    const dateUpdater = (selectedDate) => {
      setShow(false);
      if (selectedDate) {
        updateProfileData("target_date", selectedDate);
        
      }
    };

    const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'XAF',
    }).format(amount);
  };

  return (
    <SafeAreaView className="flex-1 bg-background">
      {/* Header */}
      <View className="flex flex-row justify-between items-center pt-8 pb-5 px-3 bg-white border-b border-gray-200">
        <View className="flex flex-row">
          <TouchableOpacity onPress={() => router.back()} className="mr-3">
            <ArrowLeftIcon size={24} color="#374151" />
          </TouchableOpacity>
          <View className="">
            <Text className="text-xl font-bold text-gray-900">
              Personal Savings
            </Text>
          </View>
        </View>
        <View className="flex-row items-center gap-1 space-x-3">
          <Pressable
          onPress={refreshProfiles}
          disabled={profilesLoading}
            className="mr-3"
          >
            <RefreshCwIcon
              className={`text-primary ${profilesLoading ? "opacity-50" : ""}`}
              color="#8f08fdde"
            />
          </Pressable>
          <Pressable onPress={modal.showModal}>
            <PlusCircleIcon className="text-primary" color="#8f08fdde" />
          </Pressable>
        </View>
      </View>

      <ScrollView>
        {/* introduction */}
        <View className="mx-4 px-4 border border-gray-200 py-4 flex flex-col justify-center items-center bg-white mt-3 rounded-lg">
          <Text className="font-semibold text-lg  mb-2">
            Setup a Personal saving Profile
          </Text>
          <View className="">
            <Text className="font-light">
              Choose or setup a target amount (Goal) and save toward it
            </Text>
          </View>
        </View>

        {/* different saving profile section */}
        <View className="mt-10 ml-4 mb-4">
          <Text className="font-extrabold text-gray-600 text-xl">Savings</Text>
        </View>
        {profilesLoading ? (
          <View className="flex-1 justify-center items-center mt-40">
            <ActivityIndicator size="large" color="#8f08fdde" />
            <Text>Loading..</Text>
          </View>
        ) : profiles.length > 0 ? (
          profiles.map((profile) => (
            <TouchableOpacity key={profile.id} className="bg-white border-b border-r border-l gap-2 border-gray-200 mx-3  py-4 px-2  flex flex-row justify-between items-center"
            onPress={() => router.push({ pathname: "/savings/[id]", params: { id: profile.id, name: profile.name, goal: profile.goal_amount, frequency: profile.frequency, date: profile.target_date } })}
            >
              <View className="flex flex-row gap-1">
                <View className="bg-primary/10 p-2 flex justify-center items-center rounded-full">
                    <TrendingUp size={28} className="text-primary" color="#8f08fdde" />
                </View>
                <View>
                    <Text className="font-bold text-lg">
                      {profile.name}
                    </Text>
                    <Text className="font-thin">
                      Target: {formatCurrency(profile.goal_amount)} 
                    </Text>
                </View>
              </View>
              <View>
                <Text className="font-light text-xl">
                    {profile.frequency} 
                  </Text>
              </View>
            </TouchableOpacity>
          ))
        ) : (
          <View className="mt-10 ml-4">
          <View className="flex justify-center items-center pt-20">
            <TrendingUp className="text-primary" color="#d1d5db" />
            <Text className="text-xl text-gray-300">
              No-saving-porfile-found.
            </Text>
          </View>
        </View>
        )
      }
        {/* end of it */}
        {/* end of saving profile section */}

        {/* modal for creation activity */}
        <ModalBrand
          visible={modal.isVissible}
          onrequestclose={modal.hideModal}
          title={"Create a new personal savings"}
          content={
            <View>
              <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
                Name
              </Text>
              <View>
                <InputBrand
                  value={name}
                  placeholder={"Saving Name"}
                  onchange={(text) => updateProfileData("name", text)}
                  type={"text"}
                />
              </View>

              <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
                Target Amount
              </Text>
              <View>
                <InputBrand
                  value={goal}
                  placeholder={"Amount"}
                  onchange={(text) => updateProfileData("goal", text)}
                  type={"number"}
                />
              </View>

              <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
                Target Date
              </Text>
              <TouchableOpacity
                            className="p-4 bg-gray-200 rounded-lg"
                            onPress={() => setShow(true)}
                          >
                            <Text>{target_date.toDateString()}</Text>
                          </TouchableOpacity>
                          <DateTimePicker
                            isVisible={show}
                            value={target_date}
                            mode="date"
                            display={Platform.OS === "ios" ? "spinner" : "default"}
                            onConfirm={dateUpdater}
                            onCancel={() => setShow(false)}
                          />

              <Text className="ml-2 mt-3 mb-2 font-bold text-gray-600 text-lg">
                Frequency
              </Text>
            <View className="p-2  bg-gray-200 rounded-lg flex flex-row  items-center gap-1">
              <TouchableOpacity
                onPress={() => updateProfileData("frequency", "daily")}
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
                onPress={() => updateProfileData("frequency", "weekly")}
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
                onPress={() => updateProfileData("frequency", "monthly")}
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

              <View className="mt-10">
                <ButtonBrand
                  text={"Create"}
                  fxn={handleProfileCreation}
                  disabled={!isFormValid()}
                />

                <TouchableOpacity
                          className="mt-4"
                          onPress={() => router.push("/PersonalSavings")}
                        >
                          <Text className="underline text-center font-semibold text-primary">
                            Cancel
                          </Text>
                        </TouchableOpacity>
              </View>
            </View>
          }
        />
      </ScrollView>
    </SafeAreaView>
  );
};

export default PerdonalSavings;
