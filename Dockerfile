# nginx 공식 이미지 사용
FROM nginx:alpine

# 빌드된 플러터 웹 파일 복사
COPY build/web/ /usr/share/nginx/html

# 컨테이너 시작 시 Nginx 실행
CMD ["nginx", "-g", "daemon off;"]