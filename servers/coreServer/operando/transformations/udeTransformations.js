/**
 * Created by ciprian on 7/4/17.
 */

exports.transformations = {
    updateEntity: {
        method: 'post',
        params: ["deviceId","applicationId","__body"],
        path: '/registerApplication/$deviceId/$applicationId',
        code: function (deviceId,applicationId,applicationDescription,callback) {
            startSwarm("UDESwarm.js",'registerApplication',deviceId,applicationId,applicationDescription)
            callback();
        }
    }
}