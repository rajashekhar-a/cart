FROM      node:18
RUN       useradd -m -d /app roboshop
USER      roboshop
WORKDIR   /app
COPY      package.json .
COPY      server.js .
RUN        npm install -g npm@11.1.0
CMD       ["node", "server.js"]
