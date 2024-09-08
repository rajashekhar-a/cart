FROM      node:18
RUN       useradd -m -d /app roboshop
USER      roboshop
WORKDIR   /app
COPY      package.json .
COPY      server.js .
RUN       npm install
CMD       ["node", "server.js"]