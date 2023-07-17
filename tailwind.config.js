const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
    './config/initializers/simple_form.rb',
    "./app/models/**/*.rb",
  ],
  theme: {
    extend: {
      colors: {
        primary: colors.sky[800],
        secondary: colors.sky[600],
        tertiary: colors.amber[500],
        white: "#FDFFFC",
        content: colors.gray[500],
        "primary-inverted": "#CCB7E1",
        light: colors.sky[50],
        "content-inverted": colors.gray[100],
        disable: colors.gray[200],
        transparent: 'transparent',
        current: 'currentColor',
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
