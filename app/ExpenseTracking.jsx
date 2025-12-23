import { router } from "expo-router";
import { ArrowLeftIcon, CreditCard, PlusCircleIcon } from "lucide-react-native";
import { useState } from "react";
import {
  Pressable,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
  Alert,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import ButtonBrand from "../components/ButtonBrand";
import InputBrand from "../components/InputBrand";
import ModalBrand from "../components/ModalBrand";
import useModal from "../hooks/useModal";
import { AuthContext } from "./contexts/AuthContext";
import api from "./services/api";
import useRequireAuth from "../hooks/useRequireAuth";

const ExpenseTracking = () => {
    const { user, loading: authLoading } = useRequireAuth();
    const [sendLoading, setSendLoading] = useState(false);
    const [profilesLoading, setProfilesLoading] = useState(false);
    const [profiles, setProfiles] = useState([]);
  const modal = useModal();

  const [profileData, setProfileData] = useState({
    name: "",
    description: "",
  });

  const updateProfileData = (field, value) => {
    setProfileData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  useEffect(() => {
    const fetchExpendsProfiles = async () => {
      
      setProfilesLoading(true);
      try {
        const response = await api.get("/expends_profile");
        console.log(response.data.profile);
        setProfiles(response.data.profile || []);
      }
      catch (error) {
        console.error("Failed to fetch groups:", error);
      } finally {
        setProfilesLoading(false);
      }
    };

    fetchExpendsProfiles()
  }, [user]);


  // destructuring data
  const { name, description } = profileData;

  const handleProfileCreation = async () => {
    const data = {
        name,
        description,
    }
    setSendLoading(true);
    try {
      const response = await api.post("/expends_profile", data);
      Alert.alert("Success", "Expenditure tracking profile Created successfully!");
    } catch (error){
      console.error(error);
      Alert.alert("Error", "Failed to create profile. Please try again.");
    } finally {
      setSendLoading(false)
    }
  };

  const isFormValid = () => {
    return name.trim() !== "" && description.trim() !== "";
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
              Expense Tracking
            </Text>
          </View>
        </View>
        <View>
          <Pressable onPress={modal.showModal}>
            <PlusCircleIcon className="text-primary" color="#8f08fdde" />
          </Pressable>
        </View>
      </View>

      <ScrollView>
        {/* introduction */}
        <View className="mx-4 px-4 border border-gray-200 py-4 flex flex-col justify-center items-center bg-white mt-3 rounded-lg">
          <Text className="font-semibold text-lg  mb-2">
            Setup a Expense tracking Profile
          </Text>
          <View className="">
            <Text className="font-light">Track all your expenditure</Text>
          </View>
        </View>

        {/* different saving profile section */}

        <View className="mt-10 ml-4">
          <Text className="font-extrabold text-gray-600 text-xl">Tracking</Text>
          <View className="flex justify-center items-center pt-20">
            <CreditCard className="text-primary" color="#d1d5db" />
            <Text className="text-xl text-gray-300">
              No-Tracking-porfile-found.
            </Text>
          </View>
        </View>
        {/* end of saving profile section */}

        {/* modal for creation activity */}
        <ModalBrand
          visible={modal.isVissible}
          onrequestclose={modal.hideModal}
          title={"Create a new Expense Tracking"}
          content={
            <View>
              <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
                Tracking Name
              </Text>
              <View>
                <InputBrand
                  value={name}
                  placeholder={"Tracking Name"}
                  onchange={(text) => updateProfileData("name", text)}
                  type={"text"}
                />
              </View>
              <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
                Description
              </Text>
              <View>
                <InputBrand
                  value={description}
                  placeholder={"Optional description"}
                  onchange={(text) => updateProfileData("description", text)}
                  type={"textarea"}
                />
              </View>
              <View className="mt-10">
                <ButtonBrand
                  text={"Create"}
                  fxn={handleProfileCreation}
                  disabled={!isFormValid()}
                />
              </View>
            </View>
          }
        />
      </ScrollView>
    </SafeAreaView>
  );
};

export default ExpenseTracking;
