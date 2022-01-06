FROM archlinux/archlinux:base-devel

RUN pacman -Syu --needed --noconfirm git emacs tk

ARG user=makepkg
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

RUN git clone https://aur.archlinux.org/mozart2.git
WORKDIR mozart2
RUN (echo "Y") | makepkg -si
