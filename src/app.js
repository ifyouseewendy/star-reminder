import React, { Component } from "react";
import { Layout, Button, Card, FormLayout, TextField } from "@shopify/polaris";

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      digestCount: props.digestCount,
      deliveryTime: props.deliveryTime,
    };
  }

  valueChanged() {
    return this.props.digestCount != this.state.digestCount
      || this.props.deliveryTime != this.state.deliveryTime;
  }

  renderIndex() {
    return (
      <Layout sectioned>
        <Layout.AnnotatedSection
          title="Welcome"
          description="Please authorize"
        >
          <a href="/auth/github">Github</a>
        </Layout.AnnotatedSection>
      </Layout>
    );
  }

  renderDashboard() {
    return (
      <Layout sectioned>
        <Layout.AnnotatedSection
          title="Dashboard"
          description="Update and confirm your settings"
        >
          <Card sectioned>
            <FormLayout>
              <TextField
                label="Email"
                name="email"
                type="email"
                value={this.props.email}
                disabled
              />
              <TextField
                label="Github Username"
                name="github-username"
                type="text"
                value={this.props.githubUserName}
                disabled
              />
              <TextField
                label="Delivery Time"
                name="delivery-time"
                type="datetime-local"
                value={this.state.deliveryTime}
                onChange={v => this.setState({ deliveryTime: v })}
              />
              <TextField
                label="Delivery Digest Count"
                id="hello"
                type="number"
                value={this.state.digestCount}
                min="0"
                onChange={v => this.setState({ digestCount: v })}
              />
              <Button
                primary
                url="#"
                disabled={!this.valueChanged()}
                submit
              >
                Save
              </Button>
            </FormLayout>
          </Card>
        </Layout.AnnotatedSection>
      </Layout>
    );
  }

  render() {
    if (this.props.email) {
      return this.renderDashboard();
    }
    return this.renderIndex();
  }
}

export default App;
