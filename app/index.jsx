import { router } from "expo-router";
// import LottieView from "lottie-react-native";
import React, { useRef, useState } from "react";
import {
  Dimensions,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { FlatList } from "react-native-gesture-handler";

const { width } = Dimensions.get("window");

const slides = [
  {
    id: "1",
    title: "Save Together",
    subtitle:
      "Easily contribute and manage your student njangi groups Digitally.",
    // animation: require("../../assets/lottie/save.json"),
    // animation: null,
  },
  {
    id: "2",
    title: "Stay OrganiZed",
    subtitle: "Track each member's contribution and stay transparent.",
    // animation: require("../../assets/lottie/track.json"),
    // animation: null,
  },
  {
    id: "3",
    title: "Never Miss a Turn",
    subtitle: "Get smart reminders when your contribution is due.",
    // animation: require("../../assets/lottie/reminder.json"),
    // animation: null,
  },
];

const onBoardingScreen = () => {
  const flatListRef = useRef(null);
  const [currentIndex, setCurrentIndex] = useState(0);
  const getItemLayout = (_, index) => ({
    length: width,
    offset: width * index,
    index,
  });
  const handleNext = () => {
    if (currentIndex < slides.length - 1) {
      flatListRef.current.scrollToIndex({
        index: currentIndex + 1,
        animated: true,
      });
    } else {
      router.push("/login");
    }
  };
  const handleScroll = (event) => {
    const index = Math.round(event.nativeEvent.contentOffset.x / width);
    setCurrentIndex(index);
  };
  return (
    <View style={styles.container}>
      <FlatList
        ref={flatListRef}
        data={slides}
        horizontal
        pagingEnabled
        showsHorizontalScrollIndicator={false}
        keyExtractor={(item) => item.id}
        getItemLayout={getItemLayout}
        onScroll={handleScroll}
        scrollEventThrottle={16}
        renderItem={({ item }) => (
          <View style={styles.slide}>
            {/* <LottieView source={item.animation} autoPlay style={{ height: 250 }} /> */}
            <Text style={styles.title}>{item.title}</Text>
            <Text style={styles.subtitle}>{item.subtitle}</Text>
          </View>
        )}
      />
      <TouchableOpacity style={styles.btn} onPress={handleNext}>
        <Text style={styles.btnText}>
          {currentIndex === slides.length - 1 ? "Get Started" : "Next"}
        </Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
  },
  slide: {
    width,
    alignItems: "center",
    justifyContent: "center",
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: "bold",
    color: "#222",
    marginTop: 20,
  },
  subtitle: {
    fontSize: 15,
    color: "#555",
    textAlign: "center",
    marginTop: 10,
  },
  btn: {
    backgroundColor: "#1E90FF",
    padding: 15,
    borderRadius: 25,
    alignSelf: "center",
    width: "70%",
    marginBottom: 40,
  },
  btnText: {
    color: "#fff",
    textAlign: "center",
    fontSize: 16,
    fontWeight: "bold",
  },
});

export default onBoardingScreen;
