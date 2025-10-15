import ButtonBrand from "@/components/ButtonBrand";
import { router } from "expo-router";
// import LottieView from "lottie-react-native";
import React, { useRef, useState } from "react";
import { Dimensions, StyleSheet, View } from "react-native";
import { FlatList } from "react-native-gesture-handler";
import { Text } from "react-native-paper";
import { AppTheme } from "./config/theme";

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
            <Text variant="headlineMedium" style={styles.title}>{item.title}</Text>
            <Text style={styles.subtitle}>{item.subtitle}</Text>
          </View>
        )}
      />
      <View style={styles.btn}>
        <ButtonBrand
          text={currentIndex === slides.length - 1 ? "Get Started" : "Next"}
          fxn={handleNext}
        />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    paddingLeft: 20,
    paddingRight: 20,
  },
  slide: {
    width,
    alignItems: "center",
    justifyContent: "center",
    padding: 20,
  },
  title: {
    fontWeight: "bold",
    color: AppTheme.colors.primary,
    marginTop: 20,
  },
  subtitle: {
    fontSize: 15,
    color: "#555",
    textAlign: "center",
    marginTop: 10,
    // padding: 20,
  },
  btn: {
    marginBottom: 40,
  },
});

export default onBoardingScreen;
