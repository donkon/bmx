#!/bin/sh

base=$(dirname $0)

md5tool=../file_md5

testdir=..
appsdir=../../apps
tmpdir=/tmp/timedtext_temp$$
sampledir=/tmp/


create_test_file_1()
{
    # AVCI and timed text

    $testdir/create_test_essence -t 7 -d 3 $tmpdir/video

    $appsdir/raw2bmx/raw2bmx \
        --regtest \
        -t op1a \
        -f 25 \
        -y 10:00:00:00 \
        -o $2 \
        --tt $base/$1 \
        --avci100_1080i $tmpdir/video \
        >/dev/null
}

create_test_file_2()
{
    # timed text only

    $appsdir/raw2bmx/raw2bmx \
        --regtest \
        -t op1a \
        -f 25 \
        -y 10:00:00:00 \
        --dur 100 \
        -o $2 \
        --tt $base/$1 \
        >/dev/null
}

create_test_file_3()
{
    # AVCI and 2 x timed text

    $testdir/create_test_essence -t 7 -d 3 $tmpdir/video

    $appsdir/raw2bmx/raw2bmx \
        --regtest \
        -t op1a \
        -f 25 \
        -y 10:00:00:00 \
        -o $2 \
        --tt $base/$1 \
        --tt $base/$1 \
        --avci100_1080i $tmpdir/video \
        >/dev/null
}

create_test_file_4()
{
    # AVCI, timed text, font resource and image resource

    $testdir/create_test_essence -t 7 -d 3 $tmpdir/video

    $appsdir/raw2bmx/raw2bmx \
        --regtest \
        -t op1a \
        -f 25 \
        -y 10:00:00:00 \
        -o $2 \
        --tt $base/$1 \
        --avci100_1080i $tmpdir/video \
        >/dev/null
}

create_read_result()
{
    $appsdir/mxf2raw/mxf2raw \
        --regtest \
        --info \
        --info-format xml \
        --info-file $1 \
        --ess-out $2 \
        --disable-audio \
        --disable-video \
        $3
}


check()
{
    create_test_file_1 manifest_1.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $tmpdir/test.md5 &&
        diff $tmpdir/test.md5 $base/test_1.md5 &&
        create_read_result $tmpdir/test.xml $tmpdir/test $tmpdir/test.mxf &&
            diff $tmpdir/test.xml $base/info_1.xml &&
            diff $tmpdir/test_d0.xml $base/text_example.xml &&
    create_test_file_2 manifest_1.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $tmpdir/test.md5 &&
        diff $tmpdir/test.md5 $base/test_2.md5 &&
        create_read_result $tmpdir/test.xml $tmpdir/test $tmpdir/test.mxf &&
            diff $tmpdir/test.xml $base/info_2.xml &&
            diff $tmpdir/test_d0.xml $base/text_example.xml &&
    create_test_file_3 manifest_1.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $tmpdir/test.md5 &&
        diff $tmpdir/test.md5 $base/test_3.md5 &&
        create_read_result $tmpdir/test.xml $tmpdir/test $tmpdir/test.mxf &&
            diff $tmpdir/test.xml $base/info_3.xml &&
            diff $tmpdir/test_d0.xml $base/text_example.xml &&
            diff $tmpdir/test_d1.xml $base/text_example.xml &&
    create_test_file_4 manifest_2.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $tmpdir/test.md5 &&
        diff $tmpdir/test.md5 $base/test_4.md5 &&
        create_read_result $tmpdir/test.xml $tmpdir/test $tmpdir/test.mxf &&
            diff $tmpdir/test.xml $base/info_4.xml &&
            diff $tmpdir/test_d0.xml $base/text_example.xml &&
            diff $tmpdir/test_d0_12.raw $base/font.ttf &&
            diff $tmpdir/test_d0_13.raw $base/image.png &&
    create_test_file_1 manifest_3.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $tmpdir/test.md5 &&
        diff $tmpdir/test.md5 $base/test_5.md5 &&
        create_read_result $tmpdir/test.xml $tmpdir/test $tmpdir/test.mxf &&
            diff $tmpdir/test.xml $base/info_5.xml &&
    create_test_file_1 manifest_4.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $tmpdir/test.md5 &&
        diff $tmpdir/test.md5 $base/test_6.md5 &&
        create_read_result $tmpdir/test.xml $tmpdir/test $tmpdir/test.mxf &&
            diff $tmpdir/test.xml $base/info_6.xml &&
    create_test_file_2 manifest_4.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $tmpdir/test.md5 &&
        diff $tmpdir/test.md5 $base/test_7.md5 &&
        create_read_result $tmpdir/test.xml $tmpdir/test $tmpdir/test.mxf &&
            diff $tmpdir/test.xml $base/info_7.xml
}

create_data()
{
    create_test_file_1 manifest_1.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $base/test_1.md5 &&
        create_read_result $base/info_1.xml $tmpdir/test $tmpdir/test.mxf &&
    create_test_file_2 manifest_1.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $base/test_2.md5 &&
        create_read_result $base/info_2.xml $tmpdir/test $tmpdir/test.mxf &&
    create_test_file_3 manifest_1.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $base/test_3.md5 &&
        create_read_result $base/info_3.xml $tmpdir/test $tmpdir/test.mxf &&
    create_test_file_4 manifest_2.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $base/test_4.md5 &&
        create_read_result $base/info_4.xml $tmpdir/test $tmpdir/test.mxf &&
    create_test_file_1 manifest_3.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $base/test_5.md5 &&
        create_read_result $base/info_5.xml $tmpdir/test $tmpdir/test.mxf &&
    create_test_file_1 manifest_4.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $base/test_6.md5 &&
        create_read_result $base/info_6.xml $tmpdir/test $tmpdir/test.mxf &&
    create_test_file_2 manifest_4.txt $tmpdir/test.mxf &&
        $md5tool < $tmpdir/test.mxf > $base/test_7.md5 &&
        create_read_result $base/info_7.xml $tmpdir/test $tmpdir/test.mxf
}

create_samples()
{
    create_test_file_1 manifest_1.txt $sampledir/timed_text_1.mxf &&
        create_read_result $sampledir/test_1.xml $sampledir/timed_text_1 $sampledir/timed_text_1.mxf &&
    create_test_file_2 manifest_1.txt $sampledir/timed_text_2.mxf &&
        create_read_result $sampledir/test_2.xml $sampledir/timed_text_2 $sampledir/timed_text_2.mxf &&
    create_test_file_3 manifest_1.txt $sampledir/timed_text_3.mxf &&
        create_read_result $sampledir/test_3.xml $sampledir/timed_text_3 $sampledir/timed_text_3.mxf &&
    create_test_file_4 manifest_2.txt $sampledir/timed_text_4.mxf &&
        create_read_result $sampledir/test_4.xml $sampledir/timed_text_4 $sampledir/timed_text_4.mxf &&
    create_test_file_1 manifest_3.txt $sampledir/timed_text_5.mxf &&
        create_read_result $sampledir/test_5.xml $sampledir/timed_text_5 $sampledir/timed_text_5.mxf &&
    create_test_file_1 manifest_4.txt $sampledir/timed_text_6.mxf &&
        create_read_result $sampledir/test_6.xml $sampledir/timed_text_6 $sampledir/timed_text_6.mxf &&
    create_test_file_2 manifest_4.txt $sampledir/timed_text_7.mxf &&
        create_read_result $sampledir/test_7.xml $sampledir/timed_text_7 $sampledir/timed_text_7.mxf
}


check_all()
{
    check
}

create_data_all()
{
    create_data
}

create_samples_all()
{
    create_samples
}


mkdir -p $tmpdir

if test "$1" = "create_data" ; then
    create_data_all
elif test "$1" = "create_samples" ; then
    create_samples_all
else
    check_all
fi
res=$?

rm -Rf $tmpdir

exit $res
