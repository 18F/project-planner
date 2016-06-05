
require 'yaml'
vm_config = YAML.load_file("config.yml")

required_plugins = %w(vagrant-vbguest)
project_directory = '/var/www'

required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = vm_config["server_name"]

  config.vm.network "private_network", ip: vm_config["ip_address"]

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", project_directory
  
  config.vm.network "forwarded_port", guest: 8080, host: 80
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  
  if ENV["windir"]
    config.vm.synced_folder File.expand_path("system32/drivers/", ENV["windir"]), "/winhost"
  end

  config.vm.provider "virtualbox" do |v|
    v.name = "dev-vm"
    v.cpus = vm_config["cpus"]
    v.memory = vm_config["memory_size"]
  end
  
  config.vm.provision "shell", inline: "initctl emit vagrant-ready", run: "always"
  
  config.vm.provision "shell" do |s|
    s.name = "Create swap space"
    s.inline = <<-SHELL
      memory_size="${1}"
      swap_size=$((${memory_size}*2))
      
      swapoff -a
      
      fallocate -l "${swap_size}m" /swapfile
      chmod 600 /swapfile
      mkswap /swapfile
      swapon /swapfile
      echo "/swapfile none swap sw 0 0" >> /etc/fstab
      
      sysctl vm.swappiness=10
      echo "vm.swappiness=10" >> /etc/sysctl.conf
      
      sysctl vm.vfs_cache_pressure=50
      echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
    SHELL
    
    s.args = [
      vm_config["memory_size"],
    ] 
  end
  
  config.vm.provision "shell" do |s|
    s.name = "Initialize Docker and Docker Compose"
    s.inline = <<-SHELL
      if [ "`which docker`" == "" ]; then
        echo "Installing Docker"
        wget -qO- https://get.docker.com/ | sh
        sed -i "s/^start on (local-filesystems and net-device-up IFACE!=lo)/start on vagrant-ready/" /etc/init/docker.conf
        usermod -aG docker vagrant
        echo "Docker installed successfully"
      fi
      
      if [ "`which docker-compose`" == "" ]; then
        echo "Installing Docker Compose"
        curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        echo "Docker Compose installed successfully"
      fi
    SHELL
  end
  
  config.vm.provision "shell" do |s|
    s.name = "Initialize CLI tools"
    s.inline = <<-SHELL
      project_dir="${1}"
      script_dir="${2}"
      
      echo "Adding vendor bin directory to the execution path"
      echo "PATH='$project_dir/vendor/bin:$PATH'" > /etc/profile.d/composer-vendor.sh
      
      echo "Installing CLI dependencies and workflow utilities"
      apt-get install -y build-essential libpng12-dev libjpeg-dev libpq-dev \
        php5-cli php5-dev php5-curl php5-gd php5-mysql \
        mysql-client-5.5 git
        
      echo "date.timezone = America/New_York" > /etc/php5/mods-available/timezone.ini
      php5enmod timezone
      
      drupal init -n -y
      echo "source \\"\\$HOME/.console/console.rc\\" 2>/dev/null" > /etc/profile.d/drupal-console.sh
     
      echo "Installing Composer"
      "$script_dir/composer-init.sh" -b /usr/local/bin
      
      echo "Running composer install on the project directory"
      #"$script_dir/clean.sh"
      composer install -d "$project_dir"
    SHELL
    
    s.args = [
      project_directory,
      "#{project_directory}/scripts",
    ]  
  end
  
  config.vm.provision "shell" do |s|
    s.name = "Spin up web environment"
    s.inline = <<-SHELL
      project_dir="${1}"
    
      cd "$project_dir"
      docker-compose up -d
    SHELL
            
    s.args = [
      project_directory,
    ] 
  end
end
