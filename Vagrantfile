# UTC        	for Universal Coordinated Time
# EST        	for Eastern Standard Time
# US/Central 	for American Central
# US/Eastern 	for American Eastern
# Europe/Madrid	for Europe Madrid

server_timezone  = "UTC"

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"

    # etc/hosts config: 192.168.33.22 my-project.app
    config.vm.network "private_network", ip: "192.168.50.23"

    config.vm.network "forwarded_port", guest: 80, host: 9001
    config.vm.network "forwarded_port", guest: 3306, host: 33060

    config.ssh.username = "ubuntu"
    config.ssh.password = "vagrant"
    config.ssh.insert_key = true

    config.vm.provider :virtualbox do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.name = "fenix_vm"
        vb.cpus = 1
        vb.customize ["modifyvm", :id, "--memory", "512"]
    end
    # Set share folder permissions to 777 so that apache can write files.
    config.vm.synced_folder "./public", "/home/vagrant/public", :mount_options => ["dmode=777", "fmode=666"]
    config.vm.provision :shell, :path => "bootstrap.sh", :args => [server_timezone]
    config.vm.post_up_message = <<-MESSAGE
        
          .\\            //.
        . \ \          / /.
        .\  ,\     /` /,.-
         -.   \  /'/ /  .
         ` -   `-'  \  -
           '.       /.\`
              -    .-
              :`//.'
              .`.'
              .'  FENIX VM 1.0
                  2021

    MESSAGE
end
