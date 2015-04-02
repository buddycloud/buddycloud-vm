CREATE TABLE "password-tokens" (
  "token" TEXT NOT NULL PRIMARY KEY,
  "host" TEXT NOT NULL,
  "local" TEXT NOT NULL,
  "expires" TIMESTAMP NOT NULL
);

