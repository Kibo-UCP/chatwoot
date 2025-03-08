FROM node:23-bullseye

ARG PNPM_VERSION="10.2.0"
ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN apt-get update && apt-get install -y curl git build-essential bash && \
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    ~/.rbenv/bin/rbenv install 3.3.3 && \
    ~/.rbenv/bin/rbenv global 3.3.3 && \
    ~/.rbenv/shims/gem install bundler -v '~> 2.5' && \
    npm install -g pnpm@${PNPM_VERSION}

ENV RBENV_ROOT="/root/.rbenv"
ENV PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
WORKDIR /app
COPY Gemfile Gemfile.lock ./



RUN bundle install


# Mount your current directory at runtime; no COPY statements needed
CMD ["sh", "-c", "pnpm install && bin/vite build"]
