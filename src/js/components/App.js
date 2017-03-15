import React, { Component } from 'react';
import {
  AppRegistry,
  NativeModules,
  StyleSheet,
  Text,
  View
} from 'react-native';
import Maps from './Maps';
import User from './User';
import Record from './Record';
import Library from './Library';

const AudioModule = NativeModules.AudioModule;

class App extends Component {
  constructor(props) {
    super(props);

    this.init = this.init.bind(this);
  }

  componentDidMount() {
    this.init();
  }

  async init() {
   try {
     let init = await AudioModule.init();

   } catch (e) {
     console.error(e);
   }
 }

  render() {
    return (
      <View style={styles.container}>
        <Maps />
        {/* <Record /> */}
        <User />
        {/* <Library /> */}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    alignItems: 'center',
  },
});

export default App;
