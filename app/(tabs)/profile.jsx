import { StyleSheet, Text, View } from "react-native";
import { SafeAreaView, SafeAreaProvider  } from "react-native-safe-area-context";

const Profile = () => {
  return (
    <SafeAreaProvider>
      <SafeAreaView style={{flex: 1}}>
        <View>
          <Text>Profile Screen</Text>
        </View>
      </SafeAreaView>
    </SafeAreaProvider>
  );
};

export default Profile;

const styles = StyleSheet.create({});
