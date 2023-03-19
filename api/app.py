from flask import Flask
from flask import request
from flask import jsonify
import replicate
from PIL import Image
import os

app = Flask(__name__)

REPLICATE_API = "47dcfd8c74eeb1d952d40efa0754f8f689acf3a8"

def compress(image_file):
    filepath = os.path.join(os.getcwd(), image_file)

    image = Image.open(filepath)
    basewidth = 550
    wpercent = (basewidth/float(image.size[0]))
    hsize = int((float(image.size[1])*float(wpercent)))
    
    image = image.resize((basewidth,hsize), Image.Resampling.LANCZOS)
    image.save(image_file, 
                 "JPEG", 
                 optimize = True, 
                 quality = 50)
    return


@app.route('/generate', methods=['POST'])
def generate():
    if 'file' not in request.files:
        return 'No file part in the request', 400
    
    file = request.files['file']
    # print(file.stream.read())
    if file.filename == '':
        return 'No selected file', 400

    filename = '/tmp/' + file.filename;
    file.save(filename)
    
    compress(filename)
    print(file.content_length)
    
    model = replicate.models.get("timothybrooks/instruct-pix2pix")
    version = model.versions.get("30c1d0b916a6f8efce20493f5d61ee27491ab2a60437c13c588468b9810ec23f")
    
    inputs = {
        'prompt': 'add bread to the fridge',
        'image': open(filename, 'rb'),
        'num_outputs': 1,
        'num_inference_steps': 50,
        'guidance_scale': 10.47,
        'image_guidance_scale': 1.5,
        'schedule': 'DPMSolverMultistep'
        
    }
    output = version.predict(**inputs)
    print(output)
    if len(output) < 1:
        return 'No output', 400
    print(output[0])
    return jsonify({
        'image_url': output[0]
    }), 200

if __name__ == '__main__':
    app.run()