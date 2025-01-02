module.exports = {
  content: [
    "./roda/debug_bar/views/*.erb",
    "./roda/debug_bar/views/debug_bar/*.erb",
  ],
  theme: {
    extend: {
      colors: {
        ruby: {
          50: "#faebea",
          100: "#efc0be",
          200: "#e8a29e",
          300: "#dd7772",
          400: "#d65d57",
          500: "#cc342d",
          600: "#ba2f29",
          700: "#912520",
          800: "#701d19",
          900: "#561613",
        },
      },
    },
  },
  plugins: [],
};
