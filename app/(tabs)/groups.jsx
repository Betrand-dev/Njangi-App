import { StyleSheet, Text, View } from "react-native";
import { SafeAreaView, SafeAreaProvider  } from "react-native-safe-area-context";

const Groups = () => {
  return (
    <SafeAreaProvider>
      <SafeAreaView style={{flex: 1}}>
        <View>
          <Text>Groups Screen</Text>
        </View>
      </SafeAreaView>
    </SafeAreaProvider>
  );
};

export default Groups;

const styles = StyleSheet.create({});
