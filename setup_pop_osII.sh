#!/bin/bash

## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

# Atualizar o sistema
echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar drivers necessários
echo "Instalando drivers necessários..."
sudo system76-driver-cli install

# Instalar aplicativos essenciais
echo "Instalando aplicativos essenciais..."
sudo apt install -y \
  git \
  python3 \
  python3-pip \
  vlc \
  gimp \
  gnome-tweaks \
  curl \
  chromium-browser \
  maven \
  synaptic \
  gedit

# Configurar o repositório Flatpak
echo "Configurando o repositório Flatpak..."
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Instalar aplicativos via Flatpak
echo "Instalando aplicativos via Flatpak..."
flatpak install -y flathub io.atom.Atom
flatpak install -y flathub com.wps.Office

# Adicionar repositório OpenJDK PPA e instalar o OpenJDK 21
echo "Adicionando repositório OpenJDK PPA e instalando o OpenJDK 21..."
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt update
sudo apt install -y openjdk-21-jdk

# Configurar JAVA_HOME e atualizar PATH
echo "Configurando JAVA_HOME e atualizando PATH..."
echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Instalar extensões GNOME
echo "Instalando extensões GNOME..."
sudo apt install -y gnome-shell-extensions

# Configurar backups com Deja Dup
echo "Configurando backups com Deja Dup..."
sudo apt install -y deja-dup

# Instalar e configurar Timeshift
echo "Instalando e configurando Timeshift..."
sudo apt install -y timeshift
sudo timeshift-gtk

# Configurar o UFW (Uncomplicated Firewall)
echo "Configurando o UFW (Uncomplicated Firewall)..."
sudo apt install -y ufw
sudo ufw enable
sudo ufw allow ssh

# Limpar pacotes desnecessários
echo "Limpando pacotes desnecessários..."
sudo apt autoremove -y

# Finalização
echo "Instalação e configuração concluídas com sucesso!"
java -version
echo "Verifique se o JAVA_HOME está configurado corretamente:"
echo $JAVA_HOME

# Criar a pasta de programas
PROGRAMS_DIR="/home/$USER/Downloads/programas"
mkdir -p "$PROGRAMS_DIR"
cd "$PROGRAMS_DIR"

# Função para verificar se um aplicativo está instalado
is_installed() {
  local app=$1
  if [ -f "/usr/share/applications/${app}.desktop" ]; then
    return 0
  else
    return 1
  fi
}

# Instalando o IntelliJ IDEA se não estiver instalado
if ! is_installed "idea"; then
  echo "Instalando IntelliJ IDEA..."
  sudo rm -Rf /opt/idea/
  sudo rm -Rf /usr/share/applications/idea.desktop
  wget -c https://download-cdn.jetbrains.com/idea/ideaIU-242.19890.14.tar.gz -O idea.tar.gz
  sudo tar -zxvf idea.tar.gz -C /opt/
  sudo mv /opt/idea*/ /opt/idea
  echo -e '[Desktop Entry]\nVersion=1.0\nName=idea\nExec=/opt/idea/bin/idea.sh\nIcon=/opt/idea/bin/idea.png\nType=Application\nCategories=Application' | sudo tee /usr/share/applications/idea.desktop
  sudo chmod +x /usr/share/applications/idea.desktop
  echo "IntelliJ IDEA instalado com sucesso."
else
  echo "IntelliJ IDEA já está instalado."
fi

# Instalando o Spring Tool Suite se não estiver instalado
if ! is_installed "spring"; then
  echo "Instalando Spring Tool Suite..."
  sudo rm -Rf /opt/spring/
  sudo rm -Rf /usr/share/applications/spring.desktop
  wget -c https://cdn.spring.io/spring-tools/release/STS4/4.23.1.RELEASE/dist/e4.32/spring-tool-suite-4-4.23.1.RELEASE-e4.32.0-linux.gtk.x86_64.tar.gz -O spring.tar.gz
  tar -xzvf spring.tar.gz
  sudo mv sts-4.23.1.RELEASE /opt/spring
  echo -e '[Desktop Entry]\nVersion=1.0\nName=spring\nExec=/opt/spring/SpringToolSuite4\nIcon=/opt/spring/icon.xpm\nType=Application\nCategories=Application' | sudo tee /usr/share/applications/spring.desktop
  sudo chmod +x /usr/share/applications/spring.desktop
  echo "Spring Tool Suite instalado com sucesso."
else
  echo "Spring Tool Suite já está instalado."
fi

# Limpar a pasta de programas
echo "Limpando a pasta de downloads..."
rm -rf "$PROGRAMS_DIR"

echo "Configuração concluída."

