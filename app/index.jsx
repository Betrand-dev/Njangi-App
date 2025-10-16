import ButtonBrand from "@/components/ButtonBrand";
import { router } from "expo-router";
// import LottieView from "lottie-react-native";
import React, { useRef, useState } from "react";
import { Dimensions, StyleSheet, View , Text } from "react-native";
import { FlatList } from "react-native-gesture-handler";
import { AppTheme } from "./config/theme";
import { SafeAreaView } from "react-native-safe-area-context";

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
    <SafeAreaView className="flex-1 bg-background">
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
          <View style={styles.slide} className="item-center p-12 justify-center align-center">
            {/* <LottieView source={item.animation} autoPlay style={{ height: 250 }} /> */}
            <Text className="text-primary align-center font-bold text-3xl item-center">{item.title}</Text>
            <Text className="text-gray-600 mt-4 text-lg">{item.subtitle}</Text>
          </View>
        )}
      />
      <View className="p-4">
        <ButtonBrand
          text={currentIndex === slides.length - 1 ? "Get Started" : "Next"}
          fxn={handleNext}
        />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  slide: {
    width,
    alignItems: "center",
  },
});

export default onBoardingScreen;
