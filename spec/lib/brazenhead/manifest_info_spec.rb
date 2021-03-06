require 'spec_helper'

describe Brazenhead::ManifestInfo do
  let(:process) { double('brazenhead-process').as_null_object }
  let(:manifest_info) { Brazenhead::ManifestInfo.new 'some_apk.apk' }

  before(:each) do
    Brazenhead::Process.stub(:new).and_return(process)
  end

  it "should grab the minimum sdk" do
    process.should_receive(:last_stdout).and_return("
E: uses-sdk (line=39)
A: android:minSdkVersion(0x0101020c)=(type 0x10)0x0f
A: android:targetSdkVersion(0x01010270)=(type 0x10)0xe")

    manifest_info.min_sdk.should eq 15
  end

  it "should load the manifest the first time it needs it" do
    process.should_receive(:run).with('aapt', 'dump', 'xmltree', 'some_apk.apk', 'AndroidManifest.xml')
    manifest_info.min_sdk
  end

  it "should default the minimum sdk to 1" do
    process.should_receive(:last_stdout).and_return("
E: uses-sdk (line=39)
A: android:notTheminSdkVersion(0x0101020c)=(type 0x10)0x0f
A: android:targetSdkVersion(0x01010270)=(type 0x10)0xe")

    manifest_info.min_sdk.should eq 1
  end

  it "should grab the maximum sdk" do
    process.should_receive(:last_stdout).and_return("
E: uses-sdk (line=39)
A: android:minSdkVersion(0x0101020c)=(type 0x10)0x0f
A: android:maxSdkVersion(0x0101020c)=(type 0x10)0x0a")

    manifest_info.max_sdk.should eq 10
  end

  it "should grab the target sdk" do
    process.should_receive(:last_stdout).and_return("
E: uses-sdk (line=39)
A: android:notTheminSdkVersion(0x0101020c)=(type 0x10)0x0f
A: android:targetSdkVersion(0x01010270)=(type 0x10)0xe")

    manifest_info.target_sdk.should eq 14
  end

  it "should grab the default package" do
    process.should_receive(:last_stdout).and_return("
N: android=http://schemas.android.com/apk/res/android
E: manifest (line=22)
A: package=\"com.example.android.apis\" (Raw: \"com.example.android.apis\")")

    manifest_info.package.should eq 'com.example.android.apis'
  end

end
