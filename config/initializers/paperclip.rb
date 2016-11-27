# Paperclip::FaceCrop.detectors = {
#   'OpenCV' =>  { 
#     :face => %w(/usr/local/Cellar/opencv/2.2/share/opencv/haarcascades/haarcascade_frontalface_alt_tree.xml
#                 /usr/local/Cellar/opencv/2.2/share/opencv/haarcascades/haarcascade_frontalface_alt.xml
#                 /usr/local/Cellar/opencv/2.2/share/opencv/haarcascades/haarcascade_profileface.xml)
#   }
# }
# 
Paperclip::FaceCrop.detectors = {
  'FaceCom' => { :api_key => "36b37361ac50d4790aa9cb11640db860", :api_secret => "12c8befb9b1bf952fb3bc0a1ad0e5f6c"}
}
# Paperclip::FaceCrop.debug