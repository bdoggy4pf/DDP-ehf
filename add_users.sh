#!/bin/bash

# Hunsa fyrirsagnalínu (header) og lesa frá línu 2
tail -n +2 Linux_Users.CSV | while IFS=',' read -r name firstname lastname username email department employeeid
do
  # Búa til hóp ef hann er ekki til
  if ! getent group "$department" > /dev/null; then
    groupadd "$department"
    echo "Bý til hópinn $department"
  fi

  # Búa til notanda og setja hann í réttan hóp
  useradd -m -s /bin/bash -g "$department" "$username"

  # Setja tímabundið lykilorð
  echo "$username:Temp123!" | chpasswd

  # Þvinga notanda til að breyta lykilorði við fyrstu innskráningu
  chage -d 0 "$username"

  echo "Notandi $username búinn til (nafnið: $firstname $lastname, deild: $department)"

done


