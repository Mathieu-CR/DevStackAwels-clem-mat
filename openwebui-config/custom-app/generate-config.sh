cat > /app/build/config.js << EOF
window.runtimeConfig = {
  AWELS_HOST: "${AWELS_HOST}"
};
EOF