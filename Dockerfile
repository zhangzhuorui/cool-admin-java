# 建议指定具体版本，避免 latest 镜像过大（GraalVM 镜像通常很大，t2.micro 磁盘易满）
FROM ghcr.io/graalvm/jdk:ol7-java17 

# 设置工作目录
WORKDIR /app

# [修改点] 使用通配符匹配 target 下唯一的 jar 包，并统一命名为 app.jar
# 这样无论你的版本号怎么变，后续命令都保持不变
COPY target/*.jar /app/app.jar

# [修改点] 暴露 8001 端口（保持你原来的业务端口）
EXPOSE 8001

# [修改点] 运行 app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar", "--spring.profiles.active=prod"]