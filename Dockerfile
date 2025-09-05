# nginx 공식 이미지 사용
FROM nginx:alpine

# 빌드된 플러터 웹 파일 복사
COPY web_build/ /usr/share/nginx/html

# Nginx 설정 복사
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# 컨테이너 시작 시 Nginx 실행
CMD ["nginx", "-g", "daemon off;"]