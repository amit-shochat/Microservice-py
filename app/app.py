from flask import Flask, jsonify

app = Flask(__name__)

COUNTER = 0


@app.route('/count')
# route to $domainname.blabla/count
def main():
    '''
    counter def for count HTTP requests
    '''
    global COUNTER
    COUNTER += 1
    return jsonify({'count': str(COUNTER),
                    })
    # return str(counter)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
