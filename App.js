/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component} from 'react';

import {
    Platform,
    StyleSheet,
    Text,
    View,
    Image,
    Button,
    ActivityIndicator
} from 'react-native';

import axios from 'axios';
import {Buffer} from 'buffer';

import {NativeModules} from 'react-native';
const {FileIO} = NativeModules;



export function encodeFile (response) {
    return 'data:'+response.headers['content-type'] + ';base64,'+ Buffer.from(response.data, 'binary').toString('base64');
}

export function decodeFile (base64) {
    return {uri: base64}
}

const instructions = Platform.select({
    ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
    android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});




type Props = {};
export default class App extends Component<Props> {
    constructor(props){
        super(props);
        this.state = {
            loading: false,
            status: null,
            image: null
        };
        this.onPress = this.onPress.bind(this);
        this.onSave = this.onSave.bind(this);
    }

    onSave() {
        FileIO.saveFileToGallery('myapp/downloaded.base64');
    }
    onPress() {
        this.setState({
            loading: true
        });

        axios({
            url: 'https://upload.wikimedia.org/wikipedia/commons/6/6f/HP_logo_630x630.png',
            responseType: 'arraybuffer'
        }).then(response=>{
            FileIO.saveSync('myapp/downloaded.base64', encodeFile(response));


            FileIO.read('myapp/downloaded.base64').then((base64)=>{
                this.setState({
                    status: 'Image Loaded',
                    image: decodeFile(base64)
                });
            });
            console.log('hello');

            this.setState({
                loading: false,
                status: 'Download Finished!'
            });
        }).catch((error) => {
            console.log(error);

            this.setState({
                loading: false,
                status: 'Download Failed due to internet connectivity.'
            });
        });
    }
    componentDidMount(){
        FileIO.read('myapp/downloaded.base64').then((base64)=>{
            this.setState({
                status: 'Image Loaded',
                image: decodeFile(base64)
            });
        });
    }

    render() {
        const {loading, status} = this.state;
        return (
            <View style={styles.container}>
                {this.state.image && <View style={styles.imageWrapper}>
                    <Image style={styles.image} resizeMode={'contain'} source={this.state.image}/>
                </View>}
                <Text style={styles.welcome}>
                    Welcome to React Native!
                </Text>
                {loading ? <ActivityIndicator  style={styles.indicator} size={'small'}/> : (status ? <Text>{status}</Text> : <View/>)}
                <Text style={styles.instructions}>
                    To get started, edit App.js
                </Text>
                <Text style={styles.instructions}>
                    {instructions}
                </Text>
                <Button title={'Download'} onPress={this.onPress}/>
                <Button title={'Save'} onPress={this.onSave}/>

            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    indicator: {
        margin: 10
    },
    imageWrapper: {
        flexDirection: 'row',
        justifyContent: 'center',
    },
    image: {
        flex: 1,
        width: 100,
        height: 100,
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5
    },

});
