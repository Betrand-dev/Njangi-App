import { useState } from "react";

const useModal = () => {
  const [isVissible, setIsVissible] = useState(false);

  const showModal = () => setIsVissible(true);
  const hideModal = () => setIsVissible(false);
  const toggleModal = () => setIsVissible(!isVissible);
  return {
    isVissible,
    showModal,
    hideModal,
    toggleModal,
  };
};

export default useModal;
