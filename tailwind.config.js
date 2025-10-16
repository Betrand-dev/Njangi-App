/** @type {import('tailwindcss').Config} */
module.exports = {
  // NOTE: Update this to include the paths to all files that contain Nativewind classes.
  content: ["./app/**/*", "./components/**/*.{js,jsx,ts,tsx}"],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {
      colors: {
          primary: "#8f08fdde",
          background: "#f8f9fb",
          text: "#2222",
          accent: "#ffb703",
          error: "#e63946",
      },
    },
  },
  plugins: [],
}