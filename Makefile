TARGET        = phpbrew
SIGNATURE     = $(TARGET).asc
CP            = cp
INSTALL_PATH  = /usr/local/bin
PHPUNIT       = vendor/bin/phpunit
COMPOSER      = build/bin/composer
COMPOSER_URL  = https://github.com/composer/composer/releases/download/1.10.9/composer.phar
BOX           = build/bin/box
BOX_URL       = https://github.com/humbug/box/releases/download/3.8.5/box.phar

$(COMPOSER):
	@echo 'Downloading composer'
	mkdir -p "build/bin"
	curl -sLo "$(COMPOSER)" "$(COMPOSER_URL)"
	chmod +x "$(COMPOSER)"

vendor: composer.lock $(COMPOSER)
	$(COMPOSER) install
	touch $@

$(BOX):
	@echo 'Downloading box'
	mkdir -p "build/bin"
	curl -sLo "$(BOX)" "$(BOX_URL)"
	chmod +x "$(BOX)"

$(TARGET): vendor $(BOX) $(shell find bin/ shell/ src/ -type f) box.json.dist
	PATH="$$(pwd)/build/bin:$$PATH" "$(BOX)" compile
	touch -c $@

.PHONY: update/completion
update/completion:
	bin/phpbrew zsh --bind phpbrew --program phpbrew > completion/zsh/_phpbrew
	bin/phpbrew bash --bind phpbrew --program phpbrew > completion/bash/_phpbrew

.PHONY: deps
deps: $(COMPOSER) $(BOX) vendor

.PHONY: dist
dist: $(TARGET)

.PHONY: test
test: vendor
	$(PHPUNIT) --exclude-group mayignore

.PHONY: clean
clean:
	git checkout -- $(TARGET)

.PHONY: install
install: $(TARGET)
	$(CP) $(TARGET) $(INSTALL_PATH)

.PHONY: sign
sign: $(SIGNATURE)

$(SIGNATURE): $(TARGET)
	gpg --armor --detach-sign $(TARGET)

#
# Docker tests
#
IT_RUN_UBUNTU2004 = docker run -t --rm -v $$(pwd):/work:ro -w /work ubuntu:20.04 /work/tests/test_in_docker

.PHONY: it-ubuntu20.04-php7.4
it-ubuntu20.04-php7.4: $(TARGET)
	$(IT_RUN_UBUNTU2004) 7.4

.PHONY: it-ubuntu20.04-php7.3
it-ubuntu20.04-php7.3: $(TARGET)
	$(IT_RUN_UBUNTU2004) 7.3

.PHONY: it-ubuntu20.04-php7.2
it-ubuntu20.04-php7.2: $(TARGET)
	$(IT_RUN_UBUNTU2004) 7.2

.PHONY: it-ubuntu20.04-php7.1
it-ubuntu20.04-php7.1: $(TARGET)
	$(IT_RUN_UBUNTU2004) 7.1

.PHONY: it-ubuntu20.04-php7.0
it-ubuntu20.04-php7.0: $(TARGET)
	$(IT_RUN_UBUNTU2004) 7.0

.PHONY: it-ubuntu20.04-php5.6
it-ubuntu20.04-php5.6: $(TARGET)
	$(IT_RUN_UBUNTU2004) 5.6

.PHONY: it-ubuntu20.04-php5.5
it-ubuntu20.04-php5.5: $(TARGET)
	$(IT_RUN_UBUNTU2004) 5.5

.PHONY: it-ubuntu20.04-php5.4
it-ubuntu20.04-php5.4: $(TARGET)
	$(IT_RUN_UBUNTU2004) 5.4

.PHONY: it-ubuntu20.04-php5.3
it-ubuntu20.04-php5.3: $(TARGET)
	$(IT_RUN_UBUNTU2004) 5.3
