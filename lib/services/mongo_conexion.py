from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
from bson.objectid import ObjectId
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Configura la conexión con MongoDB local
app.config["MONGO_URI"] = "mongodb://localhost:27017/appmovil"  # Cambia 'mydatabase' por el nombre de tu base de datos
mongo = PyMongo(app)

# Ruta para obtener todas las publicaciones
@app.route('/api/publications', methods=['GET'])
def get_publications():
    publications = mongo.db.publications.find()
    result = [{"id": str(pub["_id"]), **pub} for pub in publications]
    return jsonify(result), 200

# Ruta para agregar una publicación
@app.route('/api/publications', methods=['POST'])
def add_publication():
    data = request.json
    if not data:
        return jsonify({"error": "No data provided"}), 400
    inserted_id = mongo.db.publications.insert_one(data).inserted_id
    return jsonify({"id": str(inserted_id)}), 201

# Ruta para actualizar una publicación
@app.route('/api/publications/<id>', methods=['PUT'])
def update_publication(id):
    data = request.json
    if not data:
        return jsonify({"error": "No data provided"}), 400
    mongo.db.publications.update_one({"_id": ObjectId(id)}, {"$set": data})
    return jsonify({"message": "Updated successfully"}), 200

# Ruta para eliminar una publicación
@app.route('/api/publications/<id>', methods=['DELETE'])
def delete_publication(id):
    mongo.db.publications.delete_one({"_id": ObjectId(id)})
    return jsonify({"message": "Deleted successfully"}), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
