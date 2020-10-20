Help()
{
   # Display Help
   echo
   echo "Syntax: subfinder.sh domain.com"
   echo "options:"
   echo "h     Print this Help."
   echo
}
while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
     \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done
docker run -it ice3man/subfinder -d $1 | sed '1,14d' | tee $1.txt
#/usr/local/go/bin/go run subfinder/cmd/subfinder/main.go -d $1 -v -o $2
