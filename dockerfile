# ベースイメージとしてNode.jsの最新のLTSバージョンを使用
FROM node:lts-alpine

# 作業ディレクトリを作成
WORKDIR /app

# package.jsonとpackage-lock.jsonをコピー
COPY package*.json ./

# 依存関係をインストール
RUN npm install

# アプリケーションのソースコードをコピー
COPY . .

# ビルド (必要な場合)
#RUN npm run build

# ポートを公開
#EXPOSE 5173

# 起動コマンド
CMD ["npm", "run", "dev"]