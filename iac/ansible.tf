resource "null_resource" "hosts" {
 triggers = {
   public_ip1  = google_compute_instance.k8s-01.network_interface.0.access_config.0.nat_ip
   public_ip2  = google_compute_instance.k8s-02.network_interface.0.access_config.0.nat_ip
   public_ip3  = google_compute_instance.k8s-03.network_interface.0.access_config.0.nat_ip
   public_ip4  = google_compute_instance.k8s-04.network_interface.0.access_config.0.nat_ip
 }

 provisioner "remote-exec" {
   connection {
     type = "ssh"
     user = var.user
     host = google_compute_instance.k8s-01.network_interface.0.access_config.0.nat_ip
     private_key = file(var.private_key)
   }
   inline = [
     "echo OK"
   ]
 }

 provisioner "remote-exec" {
   connection {
     type = "ssh"
     user = var.user
     host = google_compute_instance.k8s-02.network_interface.0.access_config.0.nat_ip
     private_key = file(var.private_key)
   }
   inline = [
     "echo OK"
   ]
 }

 provisioner "remote-exec" {
   connection {
     type = "ssh"
     user = var.user
     host = google_compute_instance.k8s-03.network_interface.0.access_config.0.nat_ip
     private_key = file(var.private_key)
   }
   inline = [
     "echo OK"
   ]
 }

 provisioner "remote-exec" {
   connection {
     type = "ssh"
     user = var.user
     host = google_compute_instance.k8s-04.network_interface.0.access_config.0.nat_ip
     private_key = file(var.private_key)
   }
   inline = [
     "echo OK"
   ]
 }

 provisioner "remote-exec" {
   connection {
     type = "ssh"
     user = var.bastion_user
     host = var.bastion_ip
     private_key = file(var.bastion_private_key)
   }
   inline = [
     "cd ${var.ansible_home}",
     "cat << EOF > hosts",
     "[masters]",
     "master ansible_host=${var.ip1} hostname=${var.hostname1} host=${var.instance1}",
     "[workers]",
     "worker-01 ansible_host=${var.ip2} hostname=${var.hostname2} host=${var.instance2}",
     "worker-02 ansible_host=${var.ip3} hostname=${var.hostname3} host=${var.instance3}",
     "worker-03 ansible_host=${var.ip4} hostname=${var.hostname4} host=${var.instance4}",
     "[all:vars]",
     "ansible_user=${var.user}",
     "ansible_ssh_private_key_file=${var.ansible_private_key}",
     "ansible_become=yes",
     "EOF",
     "ansible-playbook -i hosts k8s.yml",
   ]
 }
}

